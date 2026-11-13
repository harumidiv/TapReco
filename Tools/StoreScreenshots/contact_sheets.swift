import AppKit
import Foundation
let root=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("output/store-screenshots")
let target=root.appendingPathComponent("previews")
try FileManager.default.createDirectory(at:target,withIntermediateDirectories:true)
for device in ["iphone","iphone-duo"] {
 for language in ["ja","en","ko","zh-Hant","es","pt-BR","id"] {
  let folder=root.appendingPathComponent("\(device)/\(language)")
  let files=try FileManager.default.contentsOfDirectory(at:folder,includingPropertiesForKeys:nil).filter{$0.pathExtension=="png"}.sorted{$0.lastPathComponent<$1.lastPathComponent}
  let h:CGFloat=460, cellW:CGFloat=device=="iphone" ? 212 : 316
  let cg=CGContext(data:nil,width:Int(cellW*5),height:Int(h+30),bitsPerComponent:8,bytesPerRow:0,space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
  cg.translateBy(x:0,y:h+30);cg.scaleBy(x:1,y:-1)
  NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
  NSColor.white.setFill();NSRect(x:0,y:0,width:cellW*5,height:h+30).fill()
  for (i,path) in files.enumerated() {
   let im=NSImage(contentsOf:path)!
   im.draw(in:NSRect(x:CGFloat(i)*cellW,y:30,width:cellW,height:h),from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,hints:[.interpolation:NSImageInterpolation.high])
  }
  ("\(device) · \(language)" as NSString).draw(at:NSPoint(x:8,y:5),withAttributes:[.font:NSFont.systemFont(ofSize:16),.foregroundColor:NSColor.black])
  NSGraphicsContext.restoreGraphicsState()
  try NSBitmapImageRep(cgImage:cg.makeImage()!).representation(using:.jpeg,properties:[.compressionFactor:0.9])!.write(to:target.appendingPathComponent("\(device)-\(language).jpg"))
 }
}
