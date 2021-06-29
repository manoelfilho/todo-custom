//
//  EmptyListView.swift
//  TodoApp
//
//  Created by Manoel Filho on 28/06/21.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: PROPERTIES
    @State private var isAnimated: Bool = false
    
    //MARK: THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    let images:[String] = [
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips: [String] = [
        "Use seu tempo com sabedoria",
        "Seja simples e prático",
        "Faça o mais complexo primeiro",
        "Recompense a si mesmo depois de um longo trabalho",
        "Organize as tarefas com antecedência",
        "Programe-se para o amanhã todas as noites"
    ]
    
    //MARK: BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("\(images.randomElement() ?? self.images[0])")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                
                Text("\(tips.randomElement() ?? self.tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .animation(.easeInOut(duration: 1.5))
            .onAppear(
                perform: {
                    self.isAnimated.toggle()
                }
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

//MARK: PREVIEW
struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environment(\.colorScheme, .dark)
    }
}
