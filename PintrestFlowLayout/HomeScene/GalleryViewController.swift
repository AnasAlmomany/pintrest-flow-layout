//
//  GalleryViewController.swift
//  New Collection design
//
//  Created by Anas Almomany on 16/01/2022.
//

import UIKit

class GalleryViewController: UIViewController {
    var collectionView: UICollectionView!
    private var layout = PinterestLayout()
    var images: [SingleImageItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        generateData()
        configureCollectionView()
    }

    func generateData() {
        images = (1...200).map({ _ in SingleImageItem.generateDumyImage() })
    }

    func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: PhotoItemCell.reuseIdentifer)

        // Set columns count
        layout.columnsCount = 2
        layout.delegate = self
        layout.contentPadding = PinterestLayout.Padding(horizontal: 5, vertical: 5)
        layout.cellsPadding = PinterestLayout.Padding(horizontal: 10, vertical: 10)

        collectionView.setContentOffset(CGPoint.zero, animated: false)
        collectionView.reloadData()
    }
}


extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.reuseIdentifer, for: indexPath) as! PhotoItemCell
        cell.photoURL = images[indexPath.row].thumbnail?.url
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Disply Full hd image
        let img = images[indexPath.row]
        let vc = ImagePreviewViewController(img: img)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}

extension GalleryViewController: PinterestLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        // Calculate size based on the layout width
        let image = images[indexPath.row]
        guard let width = image.thumbnail?.width, let height = image.thumbnail?.height else { return .zero }
        let cellWidth = layout.width
        let size = CGSize(width: Int(cellWidth), height: Int((height/width) * cellWidth))
        return size
    }
}
