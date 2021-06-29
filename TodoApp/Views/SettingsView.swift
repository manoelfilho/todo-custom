//
//  SettingsView.swift
//  TodoApp
//
//  Created by Manoel Filho on 28/06/21.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    //MARK: THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: BODY
    var body: some View {
        NavigationView{
            
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                
                Form {
                    //MARK: SECTION
                    Section(header: Text("Escolha o ícone do app")){
                        Picker(
                            selection: $iconSettings.currentIndex,
                            label: HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 1)
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 38, weight: .regular, design: .default))
                                        .foregroundColor(Color.primary)
                                }
                                .frame(width: 44, height: 44)
                                Text("Ícone do app".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                           }
                        ){
                            ForEach(0..<self.iconSettings.iconNames.count){ index in
                        
                                HStack{
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width: 8)
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }
                                .padding(.vertical, 3)
                            }
                        }
                        .onReceive([self.iconSettings.currentIndex].publisher.first()){
                            (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print("Erro ao setar icone")
                                    }else{
                                        //icone ok
                                    }
                                }
                            }
                        }.padding(.vertical, 5)
                    }
                    
                    //MARK: SECTION
                    Section(
                        header: HStack{
                            Text("Escolha o tema")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                    ){
                        List{
                            ForEach(themes, id: \.id){ item in
                                Button(
                                    action: {
                                        self.theme.themeSettings = item.id
                                        UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    }
                                ){
                                    HStack{
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                }
                                .accentColor(Color.primary)
                                
                            }
                        }
                    }
                    
                    //MARK: SECTION
                    Section(header: Text("Sites e páginas")){
                        FormRowLinkView(icon: "globe", color: Color.blue, text: "Site", link: "https://manoelfilho.eti.br")
                        FormRowLinkView(icon: "link", color: Color.pink, text: "Twitter", link: "https://twitter.com/manoelfilho")
                        FormRowLinkView(icon: "link", color: Color.green, text: "LinkdIn", link: "https://www.linkedin.com/in/manoeltsf")
                    }
                    .padding(.vertical, 3)
                    
                    //MARK: SECTION
                    Section(header: Text("Sobre o aplicativo")){
                        FormRowStaticView(icon: "gear", firstText: "Aplicativo", secondText: "Tarefas")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibilidade", secondText: "iPhone, iPad, Mac OS")
                        FormRowStaticView(icon: "keyboard", firstText: "Desenvolvedor", secondText: "@manoelfilho")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                    }
                    
                }//Final form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: Footer
                Text("Copyright © All rights reserved. \nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
                
            }//Final Vstack
            .navigationBarItems(
                trailing: Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                ){
                    Image(systemName: "xmark")
                }
            )
            .navigationBarTitle("Configurações", displayMode: .inline)
            .background(Color("ColorBackground")).edgesIgnoringSafeArea(.all)
            
        }//Final Navigation
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

//MARK: PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconNames())
    }
}
