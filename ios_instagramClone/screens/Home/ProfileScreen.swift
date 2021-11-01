//
//  ProfileScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewmodel = ProfileViewModel()
    // if project runs for real device we can change sourceType to camera
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var showingAlert = false
    @State var isScreenOpensWithNavigationView = false
    @State var isSheet: Bool = false
    
    @State var level = 1
    @State var columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: UIScreen.width - 20), spacing: 10), count: 1)
    
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
    
    func postSize() -> CGFloat {
        if level == 1 {
            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        } else if level == 2 {
            return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
        }
        return UIScreen.width/CGFloat(level) - (10 + 10/CGFloat(level))
    }
    
    func uploadImage() {
        let uid = (session.session?.uid)!
        viewmodel.apiUploadMyImage(uid: uid, image: selectedImage!, post: viewmodel.items)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        VStack {
                            if !viewmodel.imgUser.isEmpty {
                                WebImage(url: URL(string: viewmodel.imgUser)).resizable().clipShape(Circle()).frame(width: 70, height: 70).padding(.all, 2)
                            } else {
                                Image("img_person").resizable().clipShape(Circle()).frame(width: 70, height: 70).padding(.all, 2)
                            }
                        }.overlay(RoundedRectangle(cornerRadius: 37).stroke(Utils.color2, lineWidth: 2))
                        
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Button(action: {
                                    isSheet.toggle()
                                }, label: {
                                    Image(systemName: "plus.circle.fill").resizable().frame(width: 20, height: 20)
                                }).actionSheet(isPresented: $isSheet, content: {
                                    self.actionSheet
                                })
                                .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: uploadImage) {
                                    ImagePickerView(selectedImage: $selectedImage, sourceType: self.sourceType)
                                }
                            }
                        }.frame(width: 77, height: 77)
                    }
                    
                    Text(viewmodel.displayName).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium).padding(.top, 15)
                    
                    Text(viewmodel.email).foregroundColor(.gray).font(.system(size: 15)).padding(.top, 3)
                    
                    // post, following, followers counts
                    
                    HStack {
                        VStack {
                            Text(String(viewmodel.items.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Posts").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                        Divider().frame(height: 25)
                        VStack {
                            Text(String(viewmodel.followers.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Followers").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                        Divider().frame(height: 25)
                        VStack {
                            Text(String(viewmodel.following.count)).foregroundColor(.black).font(.system(size: 17)).fontWeight(.medium)
                            
                            Text("Following").foregroundColor(.gray).font(.system(size: 15))
                        }.frame(maxWidth: UIScreen.width/3, maxHeight: 60)
                    }.padding(.top, 10)
                    
                    // Post columns
                    
                    HStack {
                        Button(action: {
                            self.level = 1
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 1)
                        }, label: {
                            Image(systemName: level == 1 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                        Button(action: {
                            self.level = 2
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 2)
                        }, label: {
                            Image(systemName: level == 2 ? "rectangle.grid.2x2.fill" : "rectangle.grid.2x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                        Button(action: {
                            self.level = 3
                            self.columns = Array(repeating: GridItem(.flexible(minimum: postSize()), spacing: 10), count: 3)
                        }, label: {
                            Image(systemName: level == 3 ? "rectangle.grid.3x2.fill" : "rectangle.grid.3x2").resizable().frame(width: 20, height: 17).foregroundColor(.primary)
                        }).frame(maxWidth: UIScreen.width/3, maxHeight: 35)
                    }.padding(.top, 10).padding(.bottom, 10)
                    
                    // my posts
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewmodel.items, id: \.self) { item in
                                if let uid = session.session?.uid! {
                                    MyPostCell(uid: uid, viewmodel: viewmodel, post: item, length: postSize())
                                }
                            }
                        }
                    }.padding(.top, 10)
                }.padding(.all, 20)
                
                if viewmodel.isLoading {
                    ProgressView()
                }
                
            }
            .navigationBarTitle(viewmodel.displayName, displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAlert = true
            }, label: {
                Image(systemName: "pip.exit").resizable().scaledToFit().frame(width: 25, height: 25)
            })).alert(isPresented: $showingAlert) {
                    return Alert(title: Text("signout"),
                                 message: Text("signout_permission"),
                                 primaryButton: .destructive(Text("Confirm"), action:{ viewmodel.apiSignOut() }),
                                 secondaryButton: .cancel()
                    )
            }
        }.onAppear {
            if let uid = session.session?.uid! {
                viewmodel.apiLoadUser(uid: uid)
                viewmodel.apiPostList(uid: uid)
                viewmodel.apiLoadFollowing(uid: uid)
                viewmodel.apiLoadFollowers(uid: uid)
            }
        }
    }
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
