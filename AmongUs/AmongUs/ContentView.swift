//
//  ContentView.swift
//  AmongUs
//
//  Created by John Martin on 19/12/2020.
//  @martinsoft
//
//

import SwiftUI

struct Crewmate: View {
    
    let color: UIColor
    
    struct BodyProportions {
        
        var width: CGFloat
        var height: CGFloat
        
        let rightLegRatio: CGFloat = 0.85
        
        let legWidthLeft: CGFloat
        let legWidthRight: CGFloat
        let legHeightLeft: CGFloat
        let legHeightRight: CGFloat

        let foreheadWidth: CGFloat
        let foreheadHeight: CGFloat
        
        let rearHeadWidth: CGFloat
        let rearHeadHeight: CGFloat
        
        let frontHeight: CGFloat
        let rearHeight: CGFloat
        
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
            
            legWidthLeft = width * 0.4
            legWidthRight = legWidthLeft * rightLegRatio
            legHeightLeft = height / 5
            legHeightRight = legHeightLeft * rightLegRatio

            foreheadWidth = width / 1.9
            foreheadHeight = height * (2/5)
            
            rearHeadWidth = width / 3.5
            rearHeadHeight = height / 3.0
            
            frontHeight = height - (legHeightLeft * (1 - rightLegRatio)) - foreheadHeight
            rearHeight = height - rearHeadHeight - legHeightLeft
        }
    }
    
    struct CrewmateBody: View {
        
        let rect: CGRect
        let proportions: BodyProportions
        let color: UIColor
        var shadowColor: UIColor {
            color.darkened(by: 0.3)
        }
        let strokeStyle: StrokeStyle

        struct BodyPath: Shape {
            
            let proportions: BodyProportions
            
            func path(in rect: CGRect) -> Path {
                let width = rect.width
                let height = rect.height
            
                return Path { path in

                    // Start at bottom left
                    path.move(to: CGPoint(x: 0, y: height))

                    // Back
                    path.addLine(dx: 0, dy: -(height - proportions.rearHeadHeight))

                    // Back of head to top of head
                    path.addQuadCurve(to: CGPoint(x: proportions.rearHeadWidth, y: 0), control: CGPoint(x: width * 0.02, y: height * 0.02))

                    // Top of head
                    path.addLine(dx: width - (proportions.foreheadWidth + proportions.rearHeadWidth), dy: 0)

                    // Forehead
                    path.addQuadCurve(to: CGPoint(x: width, y: proportions.foreheadHeight), control: CGPoint(x: width * 1.0 , y: height * 0.06))

                    // RHS of body
                    path.addLine(dx: 0, dy: proportions.frontHeight)

                    // Right-side foot
                    let rightFootRight = path.currentPoint!
                    let rightFootLeft = rightFootRight.offset(dx: -proportions.legWidthRight, dy: 0)
                    let rightFootControl = CGPoint(x: (rightFootRight.x + rightFootLeft.x) / 2.0, y: rightFootRight.y * 1.03)
                    path.addQuadCurve(to: rightFootLeft, control: rightFootControl)

                    // Right leg inner
                    path.addLine(dx: 0, dy: -proportions.legHeightRight)
                    
                    path.addLine(toX: proportions.legWidthLeft)

                    // Left leg inner
                    path.addLine(dx: 0, dy: proportions.legHeightLeft)
                    
                    // Left-side foot
                    let leftFootRight = path.currentPoint!
                    let leftFootLeft = leftFootRight.offset(dx: -proportions.legWidthLeft, dy: 0)
                    let leftFootControl = CGPoint(x: (leftFootRight.x + leftFootLeft.x) / 2.0, y: leftFootRight.y * 1.07)
                    path.addQuadCurve(to: leftFootLeft, control: leftFootControl)
                }
            }
            
        }
        
        struct ShadowPath: Shape {
            
            let proportions: BodyProportions

            func path(in rect: CGRect) -> Path {
                
                let width = rect.width
                let height = rect.height
                
                return Path { path in
                    
                    let shadowTopLeft = CGPoint(
                        x: width * 0.05,
                        y: proportions.rearHeadHeight * 0.2
                    )
                    
                    let shadowTopRight = CGPoint(
                        x: width,
                        y: proportions.foreheadHeight + proportions.frontHeight * 0.1
                    )
                    
                    let shadowBottomLeft = CGPoint(
                        x: proportions.legWidthRight * 0.95,
                        y: proportions.rearHeadHeight + proportions.rearHeight * 0.75
                    )
                    
                    let shadowBottomRight = CGPoint(
                        x: width - (proportions.legWidthRight * 0.65),
                        y: shadowBottomLeft.y
                    )

                    path.move(to: shadowTopLeft)
                    path.addQuadCurve(to: shadowBottomLeft, control: CGPoint(x: proportions.legWidthLeft * 0.1, y: height * 0.6))
                    path.addQuadCurve(to: shadowBottomRight, control: CGPoint(x: width * 0.7, y: height * 0.72))
                    path.addQuadCurve(to: shadowTopRight, control: CGPoint(x: width, y: height * 0.6))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 2.0))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 2.0))
                    path.addLine(to: CGPoint(x: 0, y: proportions.rearHeadHeight))
                    path.addQuadCurve(to: shadowTopLeft, control: CGPoint(x: 0, y: 0))
                }
            }
            
        }
        
        var body: some View {
            let bodyPath = BodyPath(proportions: proportions).path(in: rect)
            let shadowPath = ShadowPath(proportions: proportions).path(in: rect)
            
            bodyPath
                .stroke(Color.black, style: strokeStyle)
            bodyPath
                .fill(Color(color))
            
            shadowPath
                .fill(Color(shadowColor))
                .mask(bodyPath)
            
            // Add the little line above the right leg
            
            Path { path in
                path.move(to: CGPoint(
                    x: rect.maxX - proportions.legWidthRight,
                    y: rect.maxY - proportions.legHeightLeft
                ))
                path.addLine(dx: 30, dy: 0)
                path.addQuadCurve(to: CGPoint(
                    x: rect.maxX - proportions.legWidthRight,
                    y: rect.maxY - proportions.legHeightLeft + strokeStyle.lineWidth / 2.0
                ), control: CGPoint(
                    x: rect.maxX * 0.7,
                    y: rect.maxY * 0.85)
                )
            }.fill(Color.black)

        }
        
    }
    
    struct Visor: View {
        
        let rect: CGRect
        let color: UIColor
        let strokeStyle: StrokeStyle
        
        var shadowColor: UIColor {
            return color.darkened(by: 0.4)
        }

        struct VisorPath: Shape {
            
            func path(in rect: CGRect) -> Path {
                
                let topMid = CGPoint(x: rect.midX, y: rect.minY)
                let bottomMid = CGPoint(x: rect.midX * 0.96, y: rect.maxY)
                let leftMid = CGPoint(x: rect.minX, y: rect.midY)
                let rightMid = CGPoint(x: rect.maxX, y: rect.midY)
                
                return Path { path in
                    path.move(to: topMid)
                    path.addQuadCurve(to: rightMid, control: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.05))
                    path.addQuadCurve(to: bottomMid, control: CGPoint(x: rect.maxX, y: rect.maxY))
                    path.addQuadCurve(to: leftMid, control: CGPoint(x: rect.minX, y: rect.maxY))
                    path.addQuadCurve(to: topMid, control: CGPoint(x: rect.minX - (rect.width * 0.03), y: rect.minY))
                }
            }
            
        }
        
        struct ShadowPath: Shape {
            
            func path(in rect: CGRect) -> Path {
                let topLeft = CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY)
                let bottomLeft = CGPoint(x: rect.minX + rect.width * 0.6, y: rect.maxY * 0.8)
                let bottomRight = CGPoint(x: rect.maxX, y: bottomLeft.y * 0.85)
                
                return Path { path in
                    path.move(to: topLeft)
                    path.addQuadCurve(to: bottomLeft, control:  CGPoint(x: rect.minX, y: rect.maxY * 0.8))
                    path.addQuadCurve(to: bottomRight, control: CGPoint(x: rect.maxX, y: rect.maxY * 0.8))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                    path.addLine(to: CGPoint(x: rect.minX - rect.width * 0.2, y: rect.maxY))
                    path.addLine(to: rect.origin)
                }
            }
        }
        
        struct HighlightPath: Shape {
            
            func path(in rect: CGRect) -> Path {
                let topMid = CGPoint(x: rect.midX * 1.01, y: rect.minY + rect.height * 0.1)
                let rightMid = CGPoint(x: rect.maxX - rect.width * 0.13, y: rect.midY * 0.8)
                let bottomMid = CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.58)
                let leftMid = CGPoint(x: rect.minX + rect.width * 0.35, y: rect.midY * 0.75)
                let leftBottom = CGPoint(x: rect.minX + rect.width * 0.46, y: rect.midY * 0.86)

                return Path { path in
                    path.move(to: topMid)
                    path.addQuadCurve(to: rightMid, control: CGPoint(x: rect.maxX * 0.9, y: rect.maxY * 0.4))
                    path.addQuadCurve(to: bottomMid, control: CGPoint(x: rect.maxX * 0.9, y: rect.maxY * 0.63))
                    path.addQuadCurve(to: leftBottom, control: CGPoint(x: rect.minX + rect.width * 0.55, y: rect.midY * 0.85))
                    path.addQuadCurve(to: leftMid, control: CGPoint(x: rect.width * 0.85, y: rect.maxY * 0.58))
                    path.addQuadCurve(to: topMid, control: CGPoint(x: rect.width * 0.82, y: rect.height * 0.56))
                }
            }
            
        }
        
        var body: some View {
            let visorPath = VisorPath().path(in: rect)
            let shadowPath = ShadowPath().path(in: rect)
            
            visorPath
                .stroke(Color.black, style: strokeStyle)
            visorPath
                .fill(Color(color))
            
            shadowPath
                .fill(Color(shadowColor))
                .mask(visorPath)
            
            HighlightPath()
                .path(in: rect)
                .fill(Color.white)
            
        }
    }
    
    struct Backpack: View {
        
        let rect: CGRect
        let color: UIColor
        let strokeStyle: StrokeStyle
        
        var shadowColor: UIColor {
            return color.darkened(by: 0.3)
        }

        struct BackpackPath: Shape {
            
            func path(in rect: CGRect) -> Path {
                
                let topLeft = CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.05)
                let topRight = CGPoint(x: rect.maxX, y: rect.minY)
                let bottomLeft = CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.9)
                let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
                
                return Path { path in
                    path.move(to: topRight)
                    path.addQuadCurve(to: topLeft, control: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY - rect.height * 0.1))
                    path.addLine(to: bottomLeft)
                    path.addQuadCurve(to: bottomRight, control: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY + rect.height * 0.09))
                    path.addLine(to: topRight)
                }
            }
            
        }
        
        struct ShadowPath: Shape {
            
            func path(in rect: CGRect) -> Path {
                let topLeft = CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.2)
                let topRight = CGPoint(x: rect.minX + rect.width, y: rect.minY + rect.height * 0.15)
                
                let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY + rect.height * 0.1)
                let bottomRight = CGPoint(x: rect.maxX, y: bottomLeft.y)
                
                return Path { path in
                    path.move(to: topRight)
                    path.addQuadCurve(to: topLeft, control: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.1))
                    path.addLine(to: bottomLeft)
                    path.addLine(to: bottomRight)
                }
            }
        }
        
        var body: some View {
            let backpackPath = BackpackPath().path(in: rect)
            let shadowPath = ShadowPath().path(in: rect)
            
            backpackPath
                .stroke(Color.black, style: strokeStyle)
            backpackPath
                .fill(Color(color))
            shadowPath
                .fill(Color(shadowColor))
                .mask(backpackPath)
            
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let rect = CGRect(origin: .zero, size: geometry.size)
            
            let strokeWidth: CGFloat = (50.0 / 280.0) * geometry.size.width

            let proportions = BodyProportions(width: rect.width, height: rect.height)
            let strokeStyle = StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
            
            let backpackWidth = proportions.legWidthLeft * 0.7
            let visorHeight = proportions.foreheadHeight * 0.75
            let visorTopY = proportions.foreheadHeight * 0.35
            
            Backpack(
                rect: CGRect(
                    x: -backpackWidth,
                    y: visorTopY + visorHeight * 0.5,
                    width: backpackWidth,
                    height: proportions.rearHeight
                ),
                color: color,
                strokeStyle: strokeStyle
            )

            CrewmateBody(
                rect: rect,
                proportions: proportions,
                color: color,
                strokeStyle: strokeStyle
            )

            Visor(
                rect: CGRect(
                    x: proportions.legWidthRight * 0.99,
                    y: visorTopY,
                    width: proportions.width - (proportions.legWidthRight * 0.8),
                    height: visorHeight
                ),
                color: UIColor(red:0.59, green:0.79, blue:0.86, alpha:1.00),
                strokeStyle: strokeStyle
            )
        }
    }

}



struct ContentView: View {

    let red = UIColor(red: 0.76, green: 0.09, blue: 0.11, alpha: 1.00)
    let yellow = UIColor.yellow
    let blue = UIColor.blue
    let shadowColor = UIColor(red: 0.22, green: 0.23, blue: 0.24, alpha: 1.00)
    
    var body: some View {
        
        let aspectRatio: CGFloat = 280.0 / 500.0
        let width: CGFloat = 200
        let height: CGFloat = width * (1.0 / aspectRatio)
        
        ZStack {
            Ellipse()
                .fill(Color(shadowColor))
                .frame(width: width * 1.55, height: 80, alignment: .bottom)
                .offset(x: 0, y: height / 1.8)
            
            Crewmate(color: yellow)
                .frame(width: width, height: height)
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




