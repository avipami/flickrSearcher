//
//  SearchView.swift
//  flickrSearcher
//
//  Created by Vincent Palma on 2024-12-05.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    TextField("Search Photos", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                    
                    Button(action: {
                        Task {
                            await viewModel.searchPhotos()
                            }
                    }) {
                        Text("Search")
                            .padding(.horizontal)
                            .padding(.vertical, .medium)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading Data...")
                    
                } else {
                    ForEach(viewModel.photos) { photo in
                        HStack {
                            AsyncImage(url: photo.thumbnailURL) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onAppear {
                                if photo.thumbnailURL == nil {
                                    print("Invalid URL for photo: \(photo.title)")
                                }
                            }
                            .padding(.trailing, .large)
                            
                            VStack(alignment: .leading) {
                                Text(photo.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text("Photo ID: \(photo.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, .small)
                        .padding(.horizontal, .large)
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}

struct FlickrSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
