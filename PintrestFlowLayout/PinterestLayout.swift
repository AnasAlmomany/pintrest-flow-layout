//
//  PinterestLayout.swift
//  New Collection design
//
//  Created by Anas Almomany on 17/01/2022.
//

import UIKit

public protocol PinterestLayoutDelegate: AnyObject {
    func cellSize(indexPath: IndexPath) -> CGSize
}

public class PinterestLayout: UICollectionViewLayout {
    public struct Padding {
        public let horizontal: CGFloat
        public let vertical: CGFloat

        public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
            self.horizontal = horizontal
            self.vertical = vertical
        }

        static var zero: Padding {
            return Padding()
        }
    }

    public var columnsCount = 5
    public var width: CGFloat = 0
    public var contentPadding: Padding = .zero
    public var cellsPadding: Padding = .zero

    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentSize: CGSize = .zero
    public weak var delegate: PinterestLayoutDelegate?

    var contentWidthWithoutPadding: CGFloat {
        return contentSize.width - 2 * contentPadding.horizontal
    }

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }

    override public func prepare() {
        super.prepare()

        cachedAttributes.removeAll()
        calculateCollectionViewFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    public func calculateCollectionViewFrames() {
        guard columnsCount > 0 else {
            fatalError("Value must be greater than zero")
        }

        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        let cellsPaddingWidth = CGFloat(columnsCount - 1) * cellsPadding.vertical
        let cellWidth = (contentWidthWithoutPadding - cellsPaddingWidth) / CGFloat(columnsCount)
        width = cellWidth
        var yOffsets = [CGFloat](repeating: contentPadding.vertical, count: columnsCount)

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)

                let cellhHeight = delegate.cellSize(indexPath: indexPath).height
                let cellSize = CGSize(width: cellWidth, height: cellhHeight)

                let y = yOffsets.min()!
                let column = yOffsets.firstIndex(of: y)!
                let x = CGFloat(column) * (cellWidth + cellsPadding.horizontal) + contentPadding.horizontal
                let origin = CGPoint(x: x, y: y)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                cachedAttributes.append(attributes)

                yOffsets[column] += cellhHeight + cellsPadding.vertical

                if isLastItem {
                    let y = yOffsets.max()!
                    for index in 0..<yOffsets.count {
                        yOffsets[index] = y
                    }
                }
            }
        }

        contentSize.height = yOffsets.max()! + contentPadding.vertical - cellsPadding.vertical
    }
}
