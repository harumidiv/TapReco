import AppKit
import CoreText
import Foundation

// Code-native store artwork: actual simulator captures inside vector device frames.
let projectRoot = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputRoot = projectRoot.appendingPathComponent("output/store-screenshots")
let toolRoot = projectRoot.appendingPathComponent("Tools/StoreScreenshots")
let copy = try JSONSerialization.jsonObject(with: Data(contentsOf: toolRoot.appendingPathComponent("copy.json"))) as! [String:[[String]]]
let characters = NSImage(contentsOf: toolRoot.appendingPathComponent("assets/characters.png"))!
var checks: [[String:Any]] = []

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> NSColor { NSColor(srgbRed:r/255,green:g/255,blue:b/255,alpha:1) }
let charcoal = color(51,51,51), coral = color(240,115,103), green = color(108,208,103), light = color(247,247,247)
func fill(_ rect: NSRect, _ color: NSColor, radius: CGFloat = 0) {
    color.setFill(); NSBezierPath(roundedRect:rect,xRadius:radius,yRadius:radius).fill()
}
func line(_ a: NSPoint, _ b: NSPoint, _ color: NSColor, width: CGFloat) {
    color.setStroke(); let p=NSBezierPath();p.move(to:a);p.line(to:b);p.lineWidth=width;p.stroke()
}
func image(_ image: NSImage, in rect: NSRect, cropTop: CGFloat = 0, cropBottom: CGFloat = 0) {
    let source = NSRect(x:0,y:cropBottom,width:image.size.width,height:image.size.height-cropTop-cropBottom)
    image.draw(in:rect,from:source,operation:.sourceOver,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high])
}
@discardableResult
func text(_ string: String, in rect: NSRect, maxSize: CGFloat, color: NSColor, weight: NSFont.Weight = .heavy, stroke: CGFloat = 0, alignment: NSTextAlignment = .center) -> CGFloat {
    let style=NSMutableParagraphStyle();style.alignment = alignment;style.lineBreakMode = .byClipping
    var size = maxSize
    func attributes(_ size: CGFloat) -> [NSAttributedString.Key:Any] {
        var a:[NSAttributedString.Key:Any] = [.font:NSFont.systemFont(ofSize:size,weight:weight),.foregroundColor:color,.paragraphStyle:style]
        if stroke != 0 { a[.strokeWidth] = stroke; a[.strokeColor] = NSColor.white }
        return a
    }
    while size > 12 && ((string as NSString).size(withAttributes:attributes(size)).width > rect.width || (string as NSString).size(withAttributes:attributes(size)).height > rect.height) { size -= 0.5 }
    let measured=(string as NSString).size(withAttributes:attributes(size))
    let r=NSRect(x:rect.minX,y:rect.minY+(rect.height-measured.height)/2,width:rect.width,height:measured.height+2)
    (string as NSString).draw(in:r,withAttributes:attributes(size))
    checks.append(["text":string,"fontSize":size,"boxWidth":rect.width,"measuredWidth":measured.width,"fits":measured.width <= rect.width+1])
    return size
}
func phone(_ screenshot: NSImage, x: CGFloat, y: CGFloat, width: CGFloat, duo: Bool) {
    let bezel=width * 0.035
    let contentWidth=width-2*bezel
    let topCrop=screenshot.size.height * (duo ? 0.028 : 0.073)
    let bottomCrop=screenshot.size.height * 0.022
    let innerHeight=contentWidth * (screenshot.size.height-topCrop-bottomCrop)/screenshot.size.width
    let cameraHeight=width * (duo ? 0.045 : 0.085)
    let shell=NSRect(x:x,y:y,width:width,height:cameraHeight+innerHeight+bezel*2)
    NSGraphicsContext.saveGraphicsState()
    let shadow=NSShadow();shadow.shadowColor=NSColor.black.withAlphaComponent(0.13);shadow.shadowBlurRadius=width*0.025;shadow.shadowOffset=NSSize(width:0,height:0);shadow.set()
    fill(shell,.white,radius:width*0.12)
    NSGraphicsContext.restoreGraphicsState()
    let inner=NSRect(x:x+bezel,y:y+bezel+cameraHeight,width:contentWidth,height:innerHeight)
    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect:inner,xRadius:width*0.075,yRadius:width*0.075).addClip()
    image(screenshot,in:inner,cropTop:topCrop,cropBottom:bottomCrop)
    NSGraphicsContext.restoreGraphicsState()
    if duo {
        fill(NSRect(x:x+width*0.45,y:y+bezel*0.7,width:width*0.10,height:width*0.012),color(128,128,128),radius:width*0.006)
    } else {
        fill(NSRect(x:x+width*0.37,y:y+bezel*0.9,width:width*0.26,height:width*0.031),color(128,128,128),radius:width*0.015)
        fill(NSRect(x:x+width*0.29,y:y+bezel*0.9,width:width*0.031,height:width*0.031),color(128,128,128),radius:width*0.015)
    }
    fill(NSRect(x:x-width*0.009,y:y+width*0.42,width:width*0.012,height:width*0.10),.white,radius:width*0.006)
    fill(NSRect(x:x-width*0.009,y:y+width*0.55,width:width*0.012,height:width*0.10),.white,radius:width*0.006)
    fill(NSRect(x:x+width-width*0.003,y:y+width*0.46,width:width*0.012,height:width*0.16),.white,radius:width*0.006)
}
func headings(_ strings:[String], w:CGFloat,h:CGFloat, accent:NSColor) {
    let inset=w*0.075
    text(strings[0],in:NSRect(x:w*0.12,y:h*0.032,width:w*0.76,height:h*0.049),maxSize:w*0.06,color:accent.blended(withFraction:0.55,of:.black)!,weight:.bold)
    for side in [false,true] {
        let x=side ? w*0.91 : w*0.07
        line(NSPoint(x:x,y:h*0.043),NSPoint(x:x+(side ? -w*0.025 : w*0.025),y:h*0.067),accent.blended(withFraction:0.55,of:.black)!,width:w*0.006)
    }
    let r=NSRect(x:inset,y:h*0.088,width:w-2*inset,height:h*0.086)
    fill(r,color(8,12,8),radius:w*0.010)
    text(strings[1],in:r.insetBy(dx:w*0.018,dy:h*0.004),maxSize:w*0.155,color:accent)
    text(strings[2],in:NSRect(x:w*0.055,y:h*0.175,width:w*0.89,height:h*0.099),maxSize:w*0.17,color:.black)
}

func sharePanel(like capture:NSImage, language:String) -> NSImage {
    let strings = try! JSONSerialization.jsonObject(with:Data(contentsOf:toolRoot.appendingPathComponent("share-copy.json"))) as! [String:[String]]
    let c=strings[language]!, w=capture.size.width, h=capture.size.height
    let cg=CGContext(data:nil,width:Int(w),height:Int(h),bitsPerComponent:8,bytesPerRow:0,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
    NSGraphicsContext.saveGraphicsState()
    cg.translateBy(x:0,y:h);cg.scaleBy(x:1,y:-1)
    NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
    fill(NSRect(x:0,y:0,width:w,height:h),color(180,183,180))
    fill(NSRect(x:0,y:h*0.075,width:w,height:h*0.925),color(248,248,248),radius:w*0.035)
    func symbol(_ name:String,_ r:NSRect) {
        if let im=NSImage(systemSymbolName:name,accessibilityDescription:nil) {
            let scale=min(r.width/im.size.width,r.height/im.size.height)
            let size=NSSize(width:im.size.width*scale,height:im.size.height*scale)
            image(im,in:NSRect(x:r.midX-size.width/2,y:r.midY-size.height/2,width:size.width,height:size.height))
        }
    }
    let unit=w*0.075
    symbol("doc",NSRect(x:w*0.05,y:h*0.105,width:unit,height:unit*1.2))
    symbol("waveform",NSRect(x:w*0.061,y:h*0.105+unit*0.43,width:unit*0.70,height:unit*0.40))
    text("2026.11.13_09-41",in:NSRect(x:w*0.16,y:h*0.105,width:w*0.59,height:unit*0.65),maxSize:w*0.04,color:.black,weight:.bold,alignment:.left)
    text(c[0]+" · 1.2 MB",in:NSRect(x:w*0.16,y:h*0.105+unit*0.65,width:w*0.59,height:unit*0.55),maxSize:w*0.033,color:.gray,weight:.regular,alignment:.left)
    fill(NSRect(x:w*0.88,y:h*0.105,width:unit,height:unit),color(232,232,232),radius:unit/2)
    symbol("xmark",NSRect(x:w*0.902,y:h*0.105+unit*0.22,width:unit*0.55,height:unit*0.55))
    line(NSPoint(x:0,y:h*0.105+unit*1.55),NSPoint(x:w,y:h*0.105+unit*1.55),color(219,219,219),width:1)
    let tile=NSRect(x:w*0.05,y:h*0.22,width:w*0.15,height:w*0.15)
    fill(tile,.white,radius:w*0.035)
    symbol("ellipsis",tile.insetBy(dx:w*0.045,dy:w*0.045))
    text(c[1],in:NSRect(x:w*0.025,y:tile.maxY+w*0.008,width:w*0.2,height:w*0.05),maxSize:w*0.028,color:.black,weight:.regular)
    for (index,label) in [c[2],c[3]].enumerated() {
        let row=NSRect(x:w*0.05,y:h*0.39+CGFloat(index)*w*0.125,width:w*0.90,height:w*0.11)
        fill(row,.white,radius:w*0.025)
        text(label,in:NSRect(x:row.minX+w*0.015,y:row.minY,width:w*0.70,height:row.height),maxSize:w*0.040,color:.black,weight:.regular,alignment:.left)
        symbol(index == 0 ? "doc.on.doc" : "folder",NSRect(x:w*0.83,y:row.minY+w*0.028,width:w*0.065,height:w*0.060))
    }
    text(c[4],in:NSRect(x:w*0.05,y:h*0.39+w*0.28,width:w*0.90,height:w*0.08),maxSize:w*0.034,color:color(0,122,255),weight:.regular,alignment:.left)
    NSGraphicsContext.restoreGraphicsState()
    return NSImage(cgImage:cg.makeImage()!,size:NSSize(width:w,height:h))
}

for device in ["iphone","iphone-duo"] {
    let duo=device == "iphone-duo"
    for language in ["ja","en","ko","zh-Hant","es","pt-BR","id"] {
        let raw=outputRoot.appendingPathComponent("raw/\(device)/\(language)")
        guard let standby=NSImage(contentsOf:raw.appendingPathComponent("standby.png")),
              let recording=NSImage(contentsOf:raw.appendingPathComponent("recording.png")),
              let list=NSImage(contentsOf:raw.appendingPathComponent("list.png")),
              let share=NSImage(contentsOf:raw.appendingPathComponent("share.png")) else { fatalError("Missing captures: \(raw.path)") }
        // Pixel dimensions are read from the unmodified simulator PNG.
        let rep=NSBitmapImageRep(data:try Data(contentsOf:raw.appendingPathComponent("standby.png")))!
        let w=CGFloat(rep.pixelsWide),h=CGFloat(rep.pixelsHigh)
        for index in 0..<5 {
            let cg=CGContext(data:nil,width:Int(w),height:Int(h),bitsPerComponent:8,bytesPerRow:0,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
            let context=NSGraphicsContext(cgContext:cg,flipped:false)
            NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=context
            context.cgContext.translateBy(x:0,y:h);context.cgContext.scaleBy(x:1,y:-1)
            let flipped=NSGraphicsContext(cgContext:context.cgContext,flipped:true);NSGraphicsContext.current=flipped
            let c=copy[language]![index]
            if index == 0 {
                fill(NSRect(x:0,y:0,width:w,height:h),charcoal)
                NSGraphicsContext.saveGraphicsState()
                NSGraphicsContext.current!.cgContext.translateBy(x:w*0.50,y:h*0.44)
                NSGraphicsContext.current!.cgContext.rotate(by: .pi/6)
                phone(standby,x:-w*0.49,y:-h*0.54,width:w*0.98,duo:duo)
                NSGraphicsContext.restoreGraphicsState()
                let artW=min(w,h*0.56/1.1)
                let artH=artW*characters.size.height/characters.size.width
                image(characters,in:NSRect(x:(w-artW)/2,y:h-artH,width:artW,height:artH))
                let heroRect=NSRect(x:w*0.055,y:h*0.064,width:w*0.89,height:h*0.092)
                text(c[0],in:heroRect,maxSize:w*0.16,color:color(165,28,16),stroke:-5)
                text(c[0],in:heroRect,maxSize:w*0.16,color:color(165,28,16))
                let band=NSRect(x:w*0.07,y:h*0.166,width:w*0.86,height:h*0.066)
                fill(band,NSColor.black.withAlphaComponent(0.88),radius:w*0.012)
                text(c[1],in:band.insetBy(dx:w*0.018,dy:h*0.003),maxSize:w*0.09,color:.white)
            } else {
                let accent:NSColor = index == 1 ? green : index == 2 ? coral : index == 3 ? color(192,192,192) : light
                fill(NSRect(x:0,y:0,width:w,height:h),accent)
                if index != 4 { fill(NSRect(x:0,y:h*0.565,width:w,height:h*0.435),charcoal) }
                headings(c,w:w,h:h,accent:accent)
                phone(index == 1 ? standby : index == 2 ? recording : index == 3 ? sharePanel(like:share,language:language) : list,
                      x:w*0.075,y:h*0.285,width:w*0.85,duo:duo)
                if index == 2 {
                    // The same UIKit slider as the app, enlarged as in reference 3.
                    fill(NSRect(x:0,y:h*0.797,width:w,height:h*0.203),color(238,238,238))
                    let sliderW=w*0.78, sliderH=sliderW*58/280
                    let slider=NSRect(x:(w-sliderW)/2,y:h*0.90-sliderH/2,width:sliderW,height:sliderH)
                    fill(slider,color(160,160,160),radius:sliderH/2)
                    let handle=sliderH*50/58, margin=(sliderH-handle)/2
                    fill(NSRect(x:slider.minX+margin,y:slider.minY+margin,width:handle,height:handle),color(34,34,34),radius:handle/2)
                    fill(NSRect(x:slider.minX+margin+handle*0.30,y:slider.minY+margin+handle*0.30,width:handle*0.40,height:handle*0.40),color(66,66,66),radius:handle*0.20)
                    fill(NSRect(x:slider.maxX-margin-handle,y:slider.minY+margin,width:handle,height:handle),color(238,238,238),radius:handle/2)
                    fill(NSRect(x:slider.maxX-margin-handle*0.66,y:slider.minY+margin+handle*0.34,width:handle*0.32,height:handle*0.32),color(160,160,160),radius:handle*0.06)
                    let catalog=try JSONSerialization.jsonObject(with:Data(contentsOf:projectRoot.appendingPathComponent("Localization/Localizable.xcstrings"))) as! [String:Any]
                    let strings=catalog["strings"] as! [String:Any]
                    let entry=strings["スライドして録音停止"] as! [String:Any]
                    let locales=entry["localizations"] as! [String:Any]
                    let localized=locales[language] as! [String:Any]
                    let unit=localized["stringUnit"] as! [String:Any]
                    text(unit["value"] as! String,in:NSRect(x:slider.minX+sliderH,y:slider.minY,width:sliderW-2*sliderH,height:sliderH),maxSize:sliderW*16/280,color:.white,weight:.bold)
                }
            }
            NSGraphicsContext.restoreGraphicsState()
            let folder=outputRoot.appendingPathComponent("\(device)/\(language)")
            try FileManager.default.createDirectory(at:folder,withIntermediateDirectories:true)
            let names=["01-record-anywhere","02-tap-to-record","03-slide-to-stop","04-share-recordings","05-recording-list"]
            try NSBitmapImageRep(cgImage:cg.makeImage()!).representation(using:.png,properties:[:])!.write(to:folder.appendingPathComponent(names[index]+".png"))
            print("\(device)/\(language)/\(names[index]).png \(Int(w))x\(Int(h))")
        }
    }
}
try JSONSerialization.data(withJSONObject:checks,options:[.prettyPrinted,.sortedKeys]).write(to:outputRoot.appendingPathComponent("typography-checks.json"))
if checks.contains(where:{($0["fits"] as? Bool) == false}) { fatalError("Text overflow") }
