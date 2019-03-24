//
//  TKHBackgroundView.swift
//  HelloLife
//
//  Created by Star童话 on 2019/3/23.
//  Copyright © 2019 STAR. All rights reserved.
//

import UIKit

/**
 * enum 背影色类型枚举值
 */
enum BackgroundColorType {
    case none
    case single
    case vertical
    case horizontal
}

/**
 * enum 边框类型枚举值
 */
enum BorderType {
    case none
    case signle
    case inner
    case move
    case upMove
}

/**
 *  enum 箭头枚举值
 */
enum PointerType {
    case none
    case left
    case right
    case top
    case bottom
}

/**
 *  enum 圆角类型
 */
enum RoundType {
    case none
    case leftTop
    case rightTop
    case leftBottom
    case rightBottom
    case all
}

struct Round {
    var radius:CGFloat
    var type:RoundType
}

struct Pointer {
    var location:CGFloat
    var type:PointerType
    // 自绘箭头是否和主题分离
    var splitPointer:Bool
    // 是否使用图片箭头
    var useImagePointer:Bool
}

func MAX_SHADOW_AND_POINTER_WIDTH() -> CGFloat {
    return 20;
}

func FLOATIS0(_ f:CGFloat) -> Bool {
    return (((f) < 0.01) && ((f) > -0.01))
}

class TKHBackgroundView: UIView {

    //MARK: - 背景属性 - Stored Properties
    var _backgroundFirstColor:UIColor?
    var _backgroundSecondColor:UIColor?
    var _backgroundColorType:BackgroundColorType = .none
    var _backgroundImage:UIImage?
    //MARK: - 背景属性 - Computed Properties
    override var backgroundColor: UIColor? {
        set {
            _backgroundFirstColor = newValue
        }
        get {
            return _backgroundFirstColor
        }
    }
    var backgroundFirstColor:UIColor? {
        set(color) {
            if _backgroundFirstColor != color {
                _backgroundFirstColor = color
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _backgroundFirstColor;
        }
    }
    var backgroundSecondColor:UIColor? {
        set(color) {
            if _backgroundSecondColor != color {
                _backgroundSecondColor = color
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _backgroundSecondColor
        }
    }
    var backgroundColorType:BackgroundColorType {
        set(type) {
            _backgroundColorType = type
            selfLayerSetNeedsDisplay()
        }
        get {
            if (_backgroundFirstColor != nil && _backgroundSecondColor != nil) {
                if (_backgroundColorType == .none || _backgroundColorType == .single) {
                    _backgroundColorType = .horizontal;
                }
            }
            else if (_backgroundFirstColor != nil && _backgroundSecondColor != nil) {
                _backgroundColorType = .none;
            }
            else {
                _backgroundColorType = .single;
            }
            return _backgroundColorType;
        }
    }
    var backgroundImage:UIImage? {
        set(image) {
            if _backgroundImage != backgroundImage {
                _backgroundImage = backgroundImage
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _backgroundImage
        }
    }

    //MARK: - 边框 Stored Properties
    var _borderMainColor:UIColor?
    var _borderMainWidth:CGFloat = 0
    var _borderSecondColor:UIColor?
    var _borderSecondWidth:CGFloat = 0
    var _borderType:BorderType = .none

    //MARK: - 边框 Computed Properties
    var borderMainColor:UIColor? {
        set(borderMainColor) {
            if (_borderMainColor != borderMainColor) {
                _borderMainColor = borderMainColor;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _borderMainColor
        }
    }
    var borderSecondColor:UIColor? {
        set(borderSecondColor) {
            if (_borderSecondColor != borderSecondColor) {
                _borderSecondColor = borderSecondColor;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _borderSecondColor
        }
    }
    var borderMainWidth:CGFloat {
        set(borderMainWidth) {
            if (_borderMainWidth != borderMainWidth) {
                _borderMainWidth = borderMainWidth;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _borderMainWidth
        }
    }
    var borderSecondWidth:CGFloat {
        set(borderSecondWidth) {
            if (_borderSecondWidth != borderSecondWidth) {
                _borderSecondWidth = borderSecondWidth;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _borderSecondWidth
        }
    }
    var borderType:BorderType {
        set(borderType) {
            if (_borderType != borderType) {
                _borderType = borderType;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _borderType
        }
    }
    
    //MARK: - 阴影 Stored Properties
    var _shadowColor:UIColor?
    var _shadowRadius:CGFloat = 5
    var _shadowOffset:CGSize = CGSize(width: 0, height: 2)

    //MARK: - 阴影 Computed Properties
    var shadowColor:UIColor? {
        set(shadowColor) {
            if (_shadowColor != shadowColor) {
                _shadowColor = shadowColor;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _shadowColor;
        }
    }
    var shadowRadius:CGFloat {
        set(shadowRadius) {
            if (_shadowRadius != shadowRadius) {
                _shadowRadius = shadowRadius;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _shadowRadius
        }
    }
    var shadowOffset:CGSize {
        set(shadowOffset) {
            _shadowOffset = shadowOffset
        }
        get {
            return _shadowOffset
        }
    }
    
//MARK: - 箭头
    var _pointer:Pointer = Pointer.init(location: 0, type: .none, splitPointer: false, useImagePointer: false)
    var pointer:Pointer {
        set(pointer) {
            _pointer = pointer
            selfLayerSetNeedsDisplay()
        }
        get {
            return _pointer
        }
    }
//MARK: - 圆角
    var _round:Round = Round.init(radius: 0, type: .none)
    var _maskRound:Bool = false
    var _roundRadius:CGFloat = 0
    var round:Round {
        set(round) {
            _round = round
            selfLayerSetNeedsDisplay()
        }
        get {
            return _round
        }
    }
    
    var roundRadius:CGFloat {
        set(roundRadius) {
            if (_round.type == .none) {
                _round.type = .all
            }
            _round.radius = roundRadius;
        }
        get {
            return _round.radius
        }
    }
    var maskRound:Bool {
        set(maskRound) {
            if (_maskRound != maskRound) {
                _maskRound = maskRound;
                selfLayerSetNeedsDisplay()
            }
        }
        get {
            return _maskRound
        }
    }

    var _drawLayer:UIImageView = UIImageView()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        propertInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:
    func propertInit() {
        self.backgroundColor = UIColor.clear
        _drawLayer.frame = self.bounds
        self.addSubview(_drawLayer)
        setDrawLayerFrame()
    }
    func setDrawLayerFrame() {
        var rect:CGRect = self.bounds
        rect.origin.x = CGFloat(-MAX_SHADOW_AND_POINTER_WIDTH());
        rect.origin.y = CGFloat(-MAX_SHADOW_AND_POINTER_WIDTH());
        rect.size.width += CGFloat(MAX_SHADOW_AND_POINTER_WIDTH() * 2);
        rect.size.height += CGFloat(MAX_SHADOW_AND_POINTER_WIDTH() * 2);
        _drawLayer.frame = rect;
    }
    //MARK: Layout
    func selfLayerSetNeedsDisplay() {
        self.layer.setNeedsDisplay()
    }
    
    override var frame: CGRect {
        set(frame) {
            let widthDiff  = frame.size.width - self.bounds.size.width;
            let heightDiff = frame.size.height - self.bounds.size.height;
            super.frame = frame
            if (!FLOATIS0(widthDiff) || !FLOATIS0(heightDiff)) {
                selfLayerSetNeedsDisplay();
                setDrawLayerFrame()
            }
        }
        get {
            return self.frame
        }
    }
    
    
    //MARK: - 绘图
    /**
     绘制带圆角带剪头的矩形框的path,如下图示
      ___________
     |           |
     |           |
    <            |
     |___________|
     @param path 画矩形框的path
     @param rect 所画矩形框的rect
     @param radius 矩形框圆角大小
     @param lineWidth 矩形边框的线宽
     @param direction 矩形框箭头方向，图示是方向为左的箭头
     @param aPoint 箭头底边中点距离原点的偏移，图示为2.5个竖线的高度
     @param aPointSize 箭头的大小，类似三角形的宽高表示（宽等于1/2底边长度）
     @param splitPointer 是否将箭头的底边画出来，类似三角形的底边
     @mark 从左上角开始绘制，逆时针的方向绘制。
     */
    func addLine(path: CGMutablePath,byRect rect:CGRect, andRadius radius:CGFloat, andLineWidth lineWidth:CGFloat, andDirection direction:PointerType, andPoint aPoint:CGFloat, andPointSize aPointSize:CGSize, splitPointer:Bool) {
        // 边框
        let left = rect.origin.x + lineWidth / 2.0
        let top = rect.origin.y + lineWidth / 2.0
        let right = left + rect.size.width - lineWidth
        let bottom = top + rect.size.height - lineWidth
        
        // 箭头宽高
        let pointerW = aPointSize.width;
        let pointerH = aPointSize.height;

        // 箭头离原点的偏移
        let pointerOffset = aPoint;
    
        path.move(to: CGPoint(x: left, y: top + radius))
        if direction == .left {
            if splitPointer {
                path.addLine(to: CGPoint(x: left, y: pointerOffset + pointerW))
                path.move(to: CGPoint(x: left, y: pointerOffset - pointerW))
            } else {
                path.addLine(to: CGPoint(x: left, y: pointerOffset - pointerW))
            }
            path.addLine(to: CGPoint(x: left - pointerH, y: pointerOffset))
            path.addLine(to: CGPoint(x: left, y: pointerOffset + pointerW))
        }
        
        path.addArc(tangent1End: CGPoint(x: left, y: bottom), tangent2End: CGPoint(x: left + radius, y: bottom), radius: radius, transform: CGAffineTransform())
        if direction == .bottom {
            if splitPointer {
                path.addLine(to: CGPoint(x: pointerOffset + pointerW, y: bottom))
                path.move(to: CGPoint(x: pointerOffset - pointerW, y: bottom))
            } else {
                path.addLine(to: CGPoint(x: pointerOffset - pointerW, y: bottom))
            }
            path.addLine(to: CGPoint(x: pointerOffset, y: bottom + pointerH))
            path.addLine(to: CGPoint(x: pointerOffset + pointerW, y: bottom))
        }
    
        path.addArc(tangent1End: CGPoint(x: right, y: bottom), tangent2End: CGPoint(x: right, y: bottom - radius), radius: radius, transform: CGAffineTransform())
        if direction == .right {
            if splitPointer {
                path.addLine(to: CGPoint(x: right, y: pointerOffset - pointerW))
                path.move(to: CGPoint(x: right, y: pointerOffset + pointerW))
            } else {
                path.addLine(to: CGPoint(x: right, y: pointerOffset + pointerW))
            }
            path.addLine(to: CGPoint(x: right + pointerH, y: pointerOffset))
            path.addLine(to: CGPoint(x: right, y: pointerOffset - pointerW))
        }
        
        path.addArc(tangent1End: CGPoint(x: right, y: top), tangent2End: CGPoint(x: right - radius, y: top), radius: radius, transform: CGAffineTransform())
        if direction == .top {
            if splitPointer {
                path.addLine(to: CGPoint(x: pointerOffset - pointerW, y: top))
                path.move(to: CGPoint(x: pointerOffset + pointerW, y: top))
            } else {
                path.addLine(to: CGPoint(x: pointerOffset + pointerW, y: top))
            }
            path.addLine(to: CGPoint(x: pointerOffset, y: top - pointerH))
            path.addLine(to: CGPoint(x: pointerOffset - pointerW, y: top))
        }
        path.addArc(tangent1End: CGPoint(x: left, y: top), tangent2End: CGPoint(x: left, y: top + radius), radius: radius, transform: CGAffineTransform())
    }
    
    func addPath(path:CGMutablePath, rect:CGRect, borderWidth:CGFloat) {
        addLine(path: path, byRect: rect, andRadius: self.round.radius - borderWidth, andLineWidth: borderWidth, andDirection: self.pointer.type, andPoint: self.pointer.location, andPointSize: CGSize(width: 10, height: 10), splitPointer: self.pointer.splitPointer)
    }
    
    func drawBounds() -> CGRect {
        let halfWidth = self.roundRadius + 5;
        var size = CGSize(width: halfWidth * 2 + 1, height: halfWidth * 2 + 1)
        switch (self.pointer.type) {
        case .right, .left:
            size.height = self.bounds.size.height;
        case .top, .bottom:
            size.width = self.bounds.size.width;
        default: break
        }
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    func addMainPath(path: CGMutablePath) {
        addPath(path: path, rect: drawBounds(), borderWidth: 0)
    }
    
    func addMainBorderPath(path: CGMutablePath) {
        var rect = drawBounds()
        switch self.borderType {
        case .none:
            return
        case .upMove:
            rect.size.height -= self.borderSecondWidth
        default:
            break
        }
        addPath(path: path, rect: rect, borderWidth: self.borderMainWidth)
    }

    func addSecondBorderPath(path: CGMutablePath) {
        var rect = drawBounds()
        let mainWidth = self.borderMainWidth
        switch self.borderType {
        case .none, .signle:
            return
        case .inner:
            rect.origin.x += mainWidth
            rect.origin.y += mainWidth
            rect.size.width -= mainWidth * 2
            rect.size.height -= mainWidth * 2
        case .move:
            rect.origin.y -= mainWidth
        case .upMove:
            rect.origin.y += mainWidth
        }
        addPath(path: path, rect: rect, borderWidth: self.borderSecondWidth)
    }
    
    func drawShadow(path: CGPath, context:CGContext?) {
        if self.shadowColor != nil  {
            context?.setShadow(offset: CGSize(width: self.shadowOffset.width, height: self.shadowOffset.height), blur: self.shadowRadius, color: self.shadowColor?.cgColor)
            // fill with solid color, but not the shadow color.
            context?.setFillColor(UIColor.white.cgColor)
            context?.addPath(path)
            context?.fillPath()
            context?.setShadow(offset: CGSize(width: 0, height: 0), blur: 0, color: nil)
            // clear non-shadow area
            context?.setBlendMode(CGBlendMode.copy)
            context?.setFillColor(UIColor.clear.cgColor)
            context?.addPath(path)
            context?.fillPath()
            context?.setBlendMode(CGBlendMode.normal)
        }
    }
    
    func drawBackground(path:CGPath, context:CGContext?) {
        switch self.backgroundColorType {
        case .none:
            // do nothing
            break
        case .single:
            if self.backgroundFirstColor != nil {
                context?.addPath(path)
                context?.setFillColor(self.backgroundFirstColor!.cgColor)
                context?.fillPath()
            }
        case .horizontal:
            // TODO:
            break
        case .vertical:
            //TODO
            break
        }
        if self.backgroundImage != nil {
            context?.saveGState()
            context?.addPath(path)
            context?.clip()
            // 背景图缩放填满
            var rect = drawBounds()
            rect.size.width += MAX_SHADOW_AND_POINTER_WIDTH()
            rect.size.height += MAX_SHADOW_AND_POINTER_WIDTH()
            context?.translateBy(x: -MAX_SHADOW_AND_POINTER_WIDTH() / 2, y: -MAX_SHADOW_AND_POINTER_WIDTH() / 2)
            context?.scaleBy(x: rect.size.width / self.backgroundImage!.size.width, y: rect.size.height / self.backgroundImage!.size.height)
            self.backgroundImage?.draw(in: CGRect(x: 0, y: 0, width: self.backgroundImage!.size.width, height: self.backgroundImage!.size.height))
            context?.restoreGState()
        }
    }
    
    func drawBorder(mainBorderPath:CGPath, secondBorderPath:CGPath, context:CGContext?) {
        if !secondBorderPath.isEmpty && self.borderSecondColor != nil {
            context?.addPath(secondBorderPath)
            context?.setStrokeColor(self.borderSecondColor!.cgColor)
            context?.setLineWidth(self.borderSecondWidth)
            context?.strokePath()
        }
        if !mainBorderPath.isEmpty && self.borderMainColor != nil {
            context?.addPath(mainBorderPath)
            context?.setStrokeColor(self.borderMainColor!.cgColor)
            context?.setLineWidth(self.borderMainWidth)
            context?.strokePath()
        }
    }
    
    func drawImagePointerInContext(context: CGContext?) {
        if !self.pointer.useImagePointer {
            return
        }
        var imgPointer:UIImage? = nil
        let p = self.pointer.location
        var rcPointer = CGRect(x: p, y: 0, width: 0, height: 0)
        switch self.pointer.type {
        case .top:
            imgPointer = UIImage(named: "menubar_arrow_down")
            if imgPointer != nil {
                rcPointer.size = imgPointer!.size;
                rcPointer.origin.x -= rcPointer.size.width / 2
                rcPointer.origin.y = drawBounds().origin.y - rcPointer.size.height
            }
        case .bottom:
            imgPointer = UIImage(named: "menubar_arrow_up")
            if imgPointer != nil {
                rcPointer.size = imgPointer!.size;
                rcPointer.origin.x -= rcPointer.size.width / 2
                rcPointer.origin.y = drawBounds().origin.y + drawBounds().size.height
            }
        default:
            break
        }
        if imgPointer != nil {
//            rcPointer.origin.x = Int(rcPointer.origin.x)
//            rcPointer.origin.y = Int(rcPointer.origin.y)
            context?.draw((imgPointer?.cgImage)!, in: rcPointer)
        }
    }
   
    func createMaskLayerWithSize(size:CGSize, path:CGPath) -> CALayer {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: MAX_SHADOW_AND_POINTER_WIDTH(), y: MAX_SHADOW_AND_POINTER_WIDTH())
        context?.setFillColor(UIColor.white.cgColor)
        context?.addPath(path)
        context?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: -MAX_SHADOW_AND_POINTER_WIDTH(), y: -MAX_SHADOW_AND_POINTER_WIDTH(), width: size.width, height: size.height)
        maskLayer.contents = image?.cgImage
        return maskLayer

    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        // 新建一块画布 大小为包括阴影和指针的大小
        let boundsSize = drawBounds().size
        let size = CGSize(width: boundsSize.width + MAX_SHADOW_AND_POINTER_WIDTH() * 2, height: boundsSize.height + MAX_SHADOW_AND_POINTER_WIDTH() * 2)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()
        // 将0，0坐标重新定位到去掉阴影的位置
        context?.translateBy(x: MAX_SHADOW_AND_POINTER_WIDTH(), y: MAX_SHADOW_AND_POINTER_WIDTH())
        let mainPath = CGMutablePath()
        let mainBorderPath = CGMutablePath()
        let secondBorderPath = CGMutablePath()
        addMainPath(path: mainPath)
        addMainBorderPath(path: mainBorderPath)
        addSecondBorderPath(path: secondBorderPath)
        drawShadow(path: mainPath, context: context)
        drawBackground(path: mainPath, context: context)
        drawBorder(mainBorderPath: mainBorderPath, secondBorderPath: secondBorderPath, context: context)
        drawImagePointerInContext(context: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        // 将实际绘制的内容贴到层上
        if image != nil {
            _drawLayer.image = image!.stretchableImage(withLeftCapWidth: Int(image!.size.width / 2), topCapHeight: Int(image!.size.height / 2))
        }
        if self.maskRound {
            var maskSize = self.bounds.size
            maskSize.width += MAX_SHADOW_AND_POINTER_WIDTH() * 2;
            maskSize.height += MAX_SHADOW_AND_POINTER_WIDTH() * 2;
            let maskPath = CGMutablePath()
            addPath(path: maskPath, rect: self.bounds, borderWidth: 0)
            self.layer.mask = createMaskLayerWithSize(size: maskSize, path: maskPath)
        }
    }
}


enum RoundRectDirection {
    case leftTop
    case leftBottom
    case rightTop
    case rightBottom
}

enum PointViewFrameDirection {
    case none
    case up
    case down
    case left
    case right
}

enum UIViewBorderStyle {
    case singelLine
    case innerSecondLine
    case moveSecondLine
}

struct PointViewFrame {
    var viewFrame:CGRect
    var pointerInView:CGFloat
    var direction:PointViewFrameDirection
}
struct UIViewMaskAndBorderView {
    var maskLayer:CALayer
    var borderImage:UIView
}
struct PointerFrame {
    var viewRect:CGRect
    var pointer:Pointer
}

extension UIView {
    func tkh_getShowToAreaFrame(rect:CGRect, view:UIView, aMarign:CGFloat) -> PointViewFrame {
        let margin = aMarign + POPOVER_POINTER_HEIGHT()
        let aViewSize = self.bounds.size
        let selfWidth = aViewSize.width
        let selfHeight = aViewSize.height
        
        var enableUp:Bool = false
        var enableDown:Bool = false
        var enableLeft:Bool = false
        var enableRight:Bool = false
        
        if (selfWidth + margin + POPOVER_MARGIN_BORDER() < rect.origin.x) {
            enableLeft = true
        }
        if (selfHeight + margin + POPOVER_MARGIN_BORDER() < rect.origin.y) {
            enableUp = true
        }
        if (selfWidth + margin + POPOVER_MARGIN_BORDER() < view.bounds.size.width - rect.origin.x - rect.size.width) {
            enableRight = true
        }
        if (selfHeight + margin + POPOVER_MARGIN_BORDER() < view.bounds.size.height - rect.origin.y - rect.size.height) {
            enableDown = true
        }
        
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        var location:CGFloat = 0.0
        var direction:PointViewFrameDirection
        if (enableDown || enableUp) {
            x = rect.origin.x + rect.size.width / 2 - selfWidth / 2
            if (x < POPOVER_MARGIN_BORDER()) {
                x = POPOVER_MARGIN_BORDER()
            } else if (x + selfWidth + POPOVER_MARGIN_BORDER() > view.bounds.size.width) {
                x = view.bounds.size.width - selfWidth - POPOVER_MARGIN_BORDER()
            }
            location = rect.origin.x + rect.size.width / 2 - x;
            y = rect.origin.y - margin - selfHeight
            if (y < 0) {
                y = rect.origin.y + rect.size.height + margin
            }
            if (y < rect.origin.y-1) {
                direction = .down
            } else {
                direction = .up
            }
        } else if (enableLeft || enableRight) {
            y = rect.origin.y + rect.size.height / 2 - selfHeight / 2
            if (y < POPOVER_MARGIN_BORDER()) {
                y = POPOVER_MARGIN_BORDER()
            } else if (y + selfHeight + POPOVER_MARGIN_BORDER() > view.bounds.size.height) {
                y = view.bounds.size.height - selfHeight - POPOVER_MARGIN_BORDER()
            }
            location = rect.origin.y + rect.size.height / 2 - y
            x = rect.origin.x - selfWidth - margin
            if (x < 0) {
                x = rect.origin.x + rect.size.width + margin
            }
            if (x < rect.origin.x-1) {
                direction = .right;
            } else {
                direction = .left;
            }
        } else {
            direction = .down;
            x = (view.bounds.size.width - selfWidth) / 2.0;
            y = (view.bounds.size.height - selfHeight ) / 2.0;
            location = aViewSize.width / 2.0;
        }
        let iframe:PointViewFrame = PointViewFrame(viewFrame: CGRect(x: CGFloat(Int(x) / 2 * 2), y: CGFloat(Int(y)), width: selfWidth, height: selfHeight), pointerInView: location, direction: direction)
        return iframe;
    }
    
    func tkh_addLine(path: CGMutablePath, rect:CGRect, radius:CGFloat, lineWidth:CGFloat, direction:PointViewFrameDirection, point:CGFloat, pointSize: CGSize) {
    
        let l:CGFloat = rect.origin.x + lineWidth / 2.0
        let t:CGFloat = rect.origin.y + lineWidth / 2.0
        let r:CGFloat = l + rect.size.width  - lineWidth - 0
        let b:CGFloat = t + rect.size.height - lineWidth - 0
        let w:CGFloat = pointSize.width
        let h:CGFloat = pointSize.height
        let p:CGFloat = point
        
        path.move(to: CGPoint(x: l, y: t+radius))
        if direction == .left {
            path.addLine(to: CGPoint(x: l, y: p-w))
            path.addLine(to: CGPoint(x: l-h, y: p))
            path.addLine(to: CGPoint(x: l, y: p+w))
        }
        path.addArc(tangent1End: CGPoint(x: l, y: b), tangent2End: CGPoint(x: l+radius, y: b), radius: radius)
        if direction == .down {
            path.addLine(to: CGPoint(x: p-w, y: b))
            path.addLine(to: CGPoint(x: p, y: b+h))
            path.addLine(to: CGPoint(x: p+w, y: b))
        }
        path.addArc(tangent1End: CGPoint(x: r, y: b), tangent2End: CGPoint(x: r, y: r-radius), radius: radius)
        if direction == .right {
            path.addLine(to: CGPoint(x: r, y: p+w))
            path.addLine(to: CGPoint(x: r+h, y: p))
            path.addLine(to: CGPoint(x: r, y: p-w))
        }
        path.addArc(tangent1End: CGPoint(x: r, y: t), tangent2End: CGPoint(x: r-radius, y: t), radius: radius)
        if direction == .up {
            path.addLine(to: CGPoint(x: p+w, y: t))
            path.addLine(to: CGPoint(x: p, y: t-h))
            path.addLine(to: CGPoint(x: p-w, y: t))
        }
        path.addArc(tangent1End: CGPoint(x: l, y: t), tangent2End: CGPoint(x: l, y: l+t), radius: radius)
    }
    
    func th_getPointer(rect:CGRect, view:UIView, aMargin:CGFloat) -> PointerFrame {
        let margin = aMargin + POPOVER_POINTER_HEIGHT()
        let viewSize = self.bounds.size
        let selfWidth = viewSize.width
        let selfHeight = viewSize.height

        var enableUp = false
        var enableDown = false
        let enableLeft = false
        let enableRight = false

        // 不允许左右箭头
        if (selfHeight + margin + POPOVER_MARGIN_RECT() < rect.origin.y) {
            enableUp = true
        }
        if (selfHeight + margin + POPOVER_MARGIN_RECT() < view.bounds.size.height - rect.origin.y - rect.size.height) {
            enableDown = true
        }
        var x:CGFloat = 0
        var y:CGFloat = 0
        var location:CGFloat = 0
        var pointer:Pointer = Pointer(location: location, type: .top, splitPointer: false, useImagePointer: false)
        if (enableDown || enableUp) {
            x = rect.origin.x + rect.size.width / 2 - selfWidth / 2;
            if (x < POPOVER_MARGIN_BORDER()) {
                x = POPOVER_MARGIN_BORDER()
            } else if (x + selfWidth + POPOVER_MARGIN_BORDER() > view.bounds.size.width) {
                x = view.bounds.size.width - selfWidth - POPOVER_MARGIN_BORDER()
            }
            location = rect.origin.x + rect.size.width / 2 - x;
            y = rect.origin.y + rect.size.height + margin;
            if y > view.bounds.size.height {
                y = rect.origin.y - margin - selfHeight;
            }
            if y >= rect.origin.y-1 {
                pointer.type = .top
            } else {
                pointer.type = .bottom
            }
        } else if (enableLeft || enableRight) {
            y = rect.origin.y + rect.size.height / 2 - selfHeight / 2;
            if y < POPOVER_MARGIN_BORDER() {
                y = POPOVER_MARGIN_BORDER()
            } else if y + selfHeight + POPOVER_MARGIN_BORDER() > view.bounds.size.height {
                y = view.bounds.size.height - selfHeight - POPOVER_MARGIN_BORDER()
            }
            location = rect.origin.y + rect.size.height / 2 - y;
            x = rect.origin.x - selfWidth - margin;
            if (x < 0) {
                x = rect.origin.x + rect.size.width + margin;
            }
            if (x < rect.origin.x-1) {
                pointer.type = .right;
            } else {
                pointer.type = .left;
            }
        } else {
            pointer.type = .bottom;
            x = (view.bounds.size.width - selfWidth) / 2.0;
            y = (view.bounds.size.height - selfHeight ) / 2.0;
            location = viewSize.width / 2.0;
        }
        let retFrame:PointerFrame = PointerFrame(viewRect: CGRect(x: CGFloat(Int(x) / 2 * 2), y: CGFloat(Int(y)), width: selfWidth, height: selfHeight), pointer: pointer)
        return retFrame;
    }
}

