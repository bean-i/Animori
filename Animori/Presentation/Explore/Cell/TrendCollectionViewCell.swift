//
//  TrendCollectionViewCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit
import FSPagerView

// MARK: - 화면 전환 프로토콜
protocol TrendCollectionViewCellDelegate: AnyObject {
    func trendCollectionViewCellTapped(_ cell: TrendCollectionViewCell, didSelectAnime anime: any AnimeProtocol)
}

// MARK: - TrendCollectionViewCell
final class TrendCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TrendCollectionViewCell"
    private var featuredItems: [any AnimeProtocol] = []
    weak var delegate: TrendCollectionViewCellDelegate?
    
    private let trendPagerView = FSPagerView()
    
    override func configureHierarchy() {
        contentView.addSubview(trendPagerView)
    }
    
    override func configureLayout() {
        trendPagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        let transformer = FSPagerViewTransformer(type: .linear)
        transformer.minimumAlpha = 0.5
        transformer.minimumScale = 0.6
        trendPagerView.transformer = transformer
        trendPagerView.scrollDirection = .horizontal
        trendPagerView.itemSize = CGSize(width: bounds.width * 0.6, height: bounds.height)
        
        trendPagerView.register(TrendPagerViewCell.self, forCellWithReuseIdentifier: TrendPagerViewCell.identifier)
        trendPagerView.delegate = self
        trendPagerView.dataSource = self
    }
    
    func configure(with items: [any AnimeProtocol]) {
        featuredItems = items
        trendPagerView.reloadData()
        
        DispatchQueue.main.async {
            guard !items.isEmpty else { return }
            self.trendPagerView.scrollToItem(at: 0, animated: true)
        }
    }
    
}

// MARK: - FSPagerView Extensions
extension TrendCollectionViewCell: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return featuredItems.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: TrendPagerViewCell.identifier, at: index) as? TrendPagerViewCell else {
            return FSPagerViewCell()
        }
        
        let item = featuredItems[index]
        cell.configureData(data: item)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let selectedAnime = featuredItems[index]
        delegate?.trendCollectionViewCellTapped(self, didSelectAnime: selectedAnime)
    }
}

// MARK: - TrendPagerViewCell
final class TrendPagerViewCell: BaseFSPagerViewCell {
    
    static let identifier = "TrendPagerViewCell"
    
    private let containView = UIView()
    private let posterImageView = UIImageView()
    private let lineView = UIView()
    
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    
    private let genreStackView = UIStackView()
    
    private var totalGenreStackViewWidth: CGFloat = 0
    private var genreStackViewWidth: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalGenreStackViewWidth = containView.frame.width - 20
        genreStackViewWidth = genreStackView.frame.width
    }

    override func configureHierarchy() {
        titleStackView.addArrangedSubviews(titleLabel, ratingLabel)

        containView.addSubViews(
            posterImageView,
            lineView,
            titleStackView,
            genreStackView
        )
        
        addSubview(containView)
    }
    
    override func configureLayout() {
        containView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(genreStackView.snp.bottom).offset(10)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(255)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.6)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        genreStackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        containView.layer.cornerRadius = 10
        containView.layer.borderWidth = 0.5
        containView.layer.borderColor = .am(.base(.white))
        containView.backgroundColor = .am(.base(.black))
        containView.clipsToBounds = true
        
        posterImageView.tintColor = .am(.base(.gray))
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        lineView.backgroundColor = .am(.base(.white))
        
        titleStackView.axis = .horizontal
        titleStackView.distribution = .equalSpacing
        titleStackView.alignment = .center
        
        titleLabel.font = .am(.titleSemibold)
        titleLabel.textColor = .am(.base(.white))
        titleLabel.textAlignment = .left
        
        ratingLabel.font = .am(.bodyRegular)
        ratingLabel.textColor = .am(.base(.white))
        ratingLabel.textAlignment = .right
        
        genreStackView.axis = .horizontal
        genreStackView.spacing = 5
        genreStackView.distribution = .fillProportionally
        genreStackView.alignment = .leading
        genreStackView.isLayoutMarginsRelativeArrangement = true
        genreStackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        genreStackView.clipsToBounds = true
    }
    
    
    func configureData(data: any AnimeProtocol) {
        posterImageView.setImage(with: data.image)
        titleLabel.text = data.title
        ratingLabel.text = "★ \(data.rate)"
        
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let availableWidth = bounds.width - 25
        var currentWidth: CGFloat = 0
        
        for tag in data.genre {
            let genreBox = GenreBoxView(genre: tag)
            let boxWidth = genreBox.intrinsicContentSize.width
            
            if currentWidth + boxWidth <= availableWidth {
                genreStackView.addArrangedSubview(genreBox)
                currentWidth += boxWidth + genreStackView.spacing
            } else {
                break
            }
        }
    }
}
