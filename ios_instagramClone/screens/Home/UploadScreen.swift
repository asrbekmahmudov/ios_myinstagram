//
//  UploadScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI

struct UploadScreen: View {
    
    @Binding var tabSelection: Int
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = UploadViewModel()
    @State var caption = ""
    // if project runs for real device we can change sourceType to camera
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State var isSheet: Bool = false
    
    var actionSheet : ActionSheet {
        let title = "Action"
        return ActionSheet(title: Text(title), buttons: [.default(Text("Pick Photo"), action: {
            self.sourceType = .photoLibrary
            self.isImagePickerDisplay.toggle()
        }), .default(Text("Take Photo"), action: {
            self.sourceType = .camera
            self.isImagePickerDisplay.toggle()
        }), .cancel(Text("Cancel"), action: {
            
            })])
    }
    
    func uploadPost() {
        if caption.isEmpty || selectedImage == nil {
            return
        }
        // Send post to server
        
        let uid = (session.session?.uid)!
        viewmodel.apiUploadPost(uid: uid, caption: caption, image: selectedImage!, completion: { result in
            if result {
                self.selectedImage = nil
                self.caption = ""
                self.tabSelection = 0
            }
        })
    }
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack {
                        if self.selectedImage != nil {
                            Image(uiImage: selectedImage!).resizable().frame(maxWidth: UIScreen.width, maxHeight: UIScreen.width).scaledToFill()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        self.selectedImage = nil
                                    }, label: {
                                        Image(systemName: "xmark.square").resizable().scaledToFit().frame(width: 25, height: 25)
                                    }).padding()
                                }
                                Spacer()
                            }
                        } else {
                            Button(action: {
                                self.isSheet.toggle()
                            }, label: {
                                Image(systemName: "camera.fill.badge.ellipsis").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(.primary)
                            }).actionSheet(isPresented: $isSheet, content: {
                                self.actionSheet
                            })
                            .sheet(isPresented: self.$isImagePickerDisplay) {
                                ImagePickerView(selectedImage: $selectedImage, sourceType: self.sourceType)
                            }
                        }
                    }.frame(maxWidth: UIScreen.width, maxHeight: UIScreen.width)
                    .background(Color.gray.opacity(0.2))
                    
                    VStack {
                        TextField("Caption", text: $caption)
                            .font(.system(size: 17, design: .default))
                            .frame(height: 45)
                        Divider()
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    Spacer()
                }
            }.navigationBarItems(trailing:
                                    Button(action: {
                                        self.uploadPost()
                                    }, label: {
                                        Image(systemName: "square.and.arrow.up").resizable().scaledToFit().frame(width: 25, height: 25)
                                    })
            )
            .navigationBarTitle("Upload", displayMode: .inline)
        }.onAppear {
            if let uid = session.session?.uid! {
                viewmodel.apiLoadFollowers(uid: uid)
            }
        }
    }
}

struct UploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        UploadScreen(tabSelection: .constant(0))
    }
}
