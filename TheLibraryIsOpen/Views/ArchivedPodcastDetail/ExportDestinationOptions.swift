import SwiftUI

struct ExportDestinationOptions: View {
    
    @Binding var showingExportOptions: Bool

    var body: some View {
        Form {
            Section("Please select a destination") {
                Button {
                    print("Files")
                } label: {
                    HStack(spacing: 15) {
                        //Spacer()
                        
                        Image(systemName: "folder.fill")
                            .foregroundColor(.blue)
                            .font(.title.bold())
                        
                        Text(LocalizableStrings.ArchivedPodcastDetail.Export.Options.filesApp)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Button {
                    print("Drive!")
                } label: {
                    HStack(spacing: 15) {
                        //Spacer()
                        
                        Image("gdrive_icon_2020")
                            .resizable()
                            .frame(width: 29, height: 26)
                        
                        Text("Google Drive")
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Button {
                    print("Drop it!")
                } label: {
                    HStack(spacing: 15) {
                        //Spacer()
                        
                        Image("dropbox_logo_2017")
                            .resizable()
                            .frame(width: 29, height: 26)
                        
                        Text("Dropbox")
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Button {
                    print("Drived!")
                } label: {
                    HStack(spacing: 15) {
                        //Spacer()
                        
                        Image("onedrive_logo_2019")
                            .resizable()
                            .frame(width: 37, height: 24)
                        
                        Text("OneDrive")
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        //.navigationTitle("Please select a destination")
    }

}

struct ExportDestinationOptions_Previews: PreviewProvider {

    static var previews: some View {
        ExportDestinationOptions(showingExportOptions: .constant(true))
    }

}
