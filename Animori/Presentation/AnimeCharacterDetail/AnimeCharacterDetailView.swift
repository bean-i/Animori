//
//  AnimeCharacterDetailView.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import UIKit
import SnapKit
import FSPagerView

final class AnimeCharacterDetailView: BaseView {
    
    private let scrollView = UIScrollView()
    private let containView = UIView()
    
    let imagePagerView = FSPagerView()
    private let nameLabel = UILabel()
    
    private let nameInfoView = CharacterInfoRowView()
    private let nicknameInfoView = CharacterInfoRowView()
    private let likedByInfoView = CharacterInfoRowView()
    
    private let introHeader = UILabel()
    let introDetailView = TranslationView(reactor: TranslationViewModel())
    private let introMoreButton = UIButton()
    
    private let voiceActorHeader = UILabel()
    let voiceActorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var characterImages: [AnimeCharacterPicturesProtocol] = []
    
    override func configureHierarchy() {
        containView.addSubViews(
            imagePagerView,
            nameInfoView,
            nicknameInfoView,
            likedByInfoView,
            introHeader,
            introDetailView,
            introMoreButton,
            voiceActorHeader,
            voiceActorCollectionView
        )
        scrollView.addSubview(containView)
        addSubview(scrollView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        containView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.bottom.equalTo(voiceActorCollectionView.snp.bottom).offset(20)
        }
        
        imagePagerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        nameInfoView.snp.makeConstraints { make in
            make.top.equalTo(imagePagerView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nicknameInfoView.snp.makeConstraints { make in
            make.top.equalTo(nameInfoView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        likedByInfoView.snp.makeConstraints { make in
            make.top.equalTo(nicknameInfoView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        introHeader.snp.makeConstraints { make in
            make.top.equalTo(likedByInfoView.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        introDetailView.snp.makeConstraints { make in
            make.top.equalTo(introHeader.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(introMoreButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(60)
        }
        
        introMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(introDetailView.snp.bottom)
            make.size.equalTo(24)
        }
        
        voiceActorHeader.snp.makeConstraints { make in
            make.top.equalTo(introDetailView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        voiceActorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(voiceActorHeader.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imagePagerView.itemSize = CGSize(width: imagePagerView.bounds.width * 0.6, height: imagePagerView.bounds.height)
        layoutIfNeeded()
    }
    
    override func configureView() {
        backgroundColor = .am(.base(.black))
        
        let transformer = FSPagerViewTransformer(type: .linear)
        transformer.minimumAlpha = 0.5
        transformer.minimumScale = 0.6
        imagePagerView.transformer = transformer
        imagePagerView.scrollDirection = .horizontal
        
        imagePagerView.register(CharacterImageCell.self, forCellWithReuseIdentifier: CharacterImageCell.identifier)
        imagePagerView.delegate = self
        imagePagerView.dataSource = self
        
        nameLabel.font = .am(.titleSemibold)
        nameLabel.textColor = .am(.base(.white))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        introHeader.text = "소개"
        introHeader.font = .am(.titleSemibold)
        introHeader.textColor = .am(.base(.white))
        introHeader.textAlignment = .left
        
        introMoreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        introMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        introMoreButton.tintColor = .am(.base(.white))
        
        voiceActorHeader.text = "성우"
        voiceActorHeader.font = .am(.titleSemibold)
        voiceActorHeader.textColor = .am(.base(.white))
        voiceActorHeader.textAlignment = .left
        
        voiceActorCollectionView.backgroundColor = .amBlack
        voiceActorCollectionView.collectionViewLayout = configureVoiceActorLayout()
        voiceActorCollectionView.showsVerticalScrollIndicator = false
        voiceActorCollectionView.showsHorizontalScrollIndicator = false
        voiceActorCollectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
    }
    
    func configureData(data: AnimeCharacterInfoProtocol) {
        nameInfoView.configure(title: "일본어 이름", value: data.kanjiName)
        nicknameInfoView.configure(title: "닉네임", value: data.nickname)
        likedByInfoView.configure(title: "저장한 사람", value: data.favorites, isSeparator: true)
        introDetailView.setText(data.about)
    }
    
    private func configureVoiceActorLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 100, height: 150)
        return layout
    }
    
    @objc private func moreButtonTapped() {
        print("yes")
        introDetailView.toggleExpand()
        
        // 아이콘 토글
        let isExpandedNow = introDetailView.isExpanded
        let iconName = isExpandedNow ? "chevron.up" : "chevron.down"
        introMoreButton.setImage(UIImage(systemName: iconName), for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


extension AnimeCharacterDetailView: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return characterImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CharacterImageCell.identifier, at: index) as? CharacterImageCell else {
            return FSPagerViewCell()
        }
        
        let item = characterImages[index]
        cell.configureData(data: item.image)
        return cell
    }
    
}
