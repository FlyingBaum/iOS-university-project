//
//  ContentView.swift
//  iOS6-NguyenBaliev
//
//  Created by Krist Baliev on 30.01.22.
//

import SwiftUI

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width,
               height: lhs.height + rhs.height)
    }
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }
}

struct ContentView: View {
    
    @State private var currentDragOffset = CGSize.zero
    @State private var finalDragOffset = CGSize.zero
    
    @State private var currentScaling = CGFloat(1)
    @State private var finalScaling = CGFloat(1)
    
    @State private var currentAngle = Angle()
    @State private var finalAngle = Angle()
    
    @State private var isAnimating = true // toggle state
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                currentDragOffset = value.translation
            }
            .onEnded { value in
                if(!isAnimating){
                    finalDragOffset += value.translation
                    currentDragOffset = .zero
                }
                else{
                    withAnimation(.spring(dampingFraction: 0.6)){
                        finalDragOffset = CGSize.zero
                        currentDragOffset = CGSize.zero
                    }
                }
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                currentScaling = value.magnitude
            }
            .onEnded { value in
                if(!isAnimating){
                    finalScaling *= value.magnitude
                    currentScaling = CGFloat(1)
                }
                else{
                    withAnimation(.spring(dampingFraction: 0.6)){
                        finalScaling = CGFloat(1)
                        currentScaling = CGFloat(1)
                    }
                }
            }
    }
    
    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { value in
                currentAngle.degrees = value.degrees
            }
            .onEnded { value in
                if(!isAnimating){
                    finalAngle.degrees += value.degrees
                    currentAngle.degrees = .zero
                }
                else{
                    withAnimation(.spring(dampingFraction: 0.6)){
                        finalAngle.degrees = .zero
                        currentAngle.degrees = .zero
                    }
                    
                }
            }
    }
    
    var body: some View {
        VStack{
            Image("Ness").resizable()
                .aspectRatio(1, contentMode: .fit).offset(currentDragOffset + finalDragOffset).gesture(dragGesture).scaleEffect(currentScaling * finalScaling)
                .simultaneousGesture(magnificationGesture).rotationEffect(currentAngle + finalAngle)
                .simultaneousGesture(rotationGesture)
            
            Toggle(isOn: $isAnimating) {
                Text("ANIMATE BACK").foregroundColor(.white).background(.black)
            }.frame(width: 200, height: 0, alignment: .topLeading).padding(.top, 100.0)
        }.background(Image("Home"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
