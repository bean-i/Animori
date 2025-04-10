////
////  AnimeMockData.swift
////  Animori
////
////  Created by 이빈 on 3/29/25.
////
//
//import Foundation
//
//let mockAnimeResponseDTO = AnimeResponseDTO(data: [
//    AnimeDTO(
//        id: 58567,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1448/147351.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1448/147351l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Ore dake Level Up na Ken Season 2: Arise from the Shadow"),
//            AnimeTitle(type: "Synonym", title: "Solo Leveling Second Season"),
//            AnimeTitle(type: "Japanese", title: "俺だけレベルアップな件 Season 2 -Arise from the Shadow-"),
//            AnimeTitle(type: "English", title: "Solo Leveling Season 2: Arise from the Shadow")
//        ],
//        score: 8.87,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    ),
//    AnimeDTO(
//        id: 58514,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1025/147458.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1025/147458l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Kusuriya no Hitorigoto 2nd Season"),
//            AnimeTitle(type: "Synonym", title: "The Pharmacist's Monologue"),
//            AnimeTitle(type: "Synonym", title: "Drugstore Soliloquy"),
//            AnimeTitle(type: "Japanese", title: "薬屋のひとりごと 第2期"),
//            AnimeTitle(type: "English", title: "The Apothecary Diaries Season 2")
//        ],
//        score: 8.8,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 8, name: "Drama"),
//            AnimeGenre(id: 7, name: "Mystery")
//        ]
//    ),
//    AnimeDTO(
//        id: 55255,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1524/143502.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1524/143502l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Alien Stage"),
//            AnimeTitle(type: "Japanese", title: "ALIEN STAGE (에일리언스테이지)"),
//            AnimeTitle(type: "English", title: "Alien Stage")
//        ],
//        score: 8.79,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 8, name: "Drama"),
//            AnimeGenre(id: 24, name: "Sci-Fi"),
//            AnimeGenre(id: 41, name: "Suspense")
//        ]
//    ),
//    AnimeDTO(
//        id: 21,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1244/138851.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1244/138851l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "One Piece"),
//            AnimeTitle(type: "Synonym", title: "OP"),
//            AnimeTitle(type: "Japanese", title: "ONE PIECE"),
//            AnimeTitle(type: "English", title: "One Piece")
//        ],
//        score: 8.73,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    ),
//    AnimeDTO(
//        id: 60988,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1182/147971.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1182/147971l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Tian Guan Cifu Short Film"),
//            AnimeTitle(type: "Japanese", title: "天官賜福 短片"),
//            AnimeTitle(type: "English", title: "Heaven Official's Blessing Short Film")
//        ],
//        score: 8.49,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 8, name: "Drama"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    ),
//    AnimeDTO(
//        id: 51039,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1419/126374.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1419/126374l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Doupo Cangqiong: Nian Fan"),
//            AnimeTitle(type: "Synonym", title: "Battle Through The Heavens 5th"),
//            AnimeTitle(type: "Synonym", title: "6th & 7th Seasons"),
//            AnimeTitle(type: "Japanese", title: "斗破苍穹年番")
//        ],
//        score: 8.45,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    ),
//    AnimeDTO(
//        id: 56524,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1212/138218.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1212/138218l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Tunshi Xingkong 4th Season"),
//            AnimeTitle(type: "Japanese", title: "吞噬星空 第四季"),
//            AnimeTitle(type: "English", title: "Swallowed Star 4th Season")
//        ],
//        score: 8.37,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy"),
//            AnimeGenre(id: 24, name: "Sci-Fi")
//        ]
//    ),
//    AnimeDTO(
//        id: 55809,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1542/136768.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1542/136768l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Xian Ni"),
//            AnimeTitle(type: "Japanese", title: "仙逆"),
//            AnimeTitle(type: "English", title: "Renegade Immortal")
//        ],
//        score: 8.33,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    ),
//    AnimeDTO(
//        id: 58572,
//        images: AnimeImage(
//            jpg: AnimeJPG(
//                imageURL: "https://cdn.myanimelist.net/images/anime/1996/147601.jpg",
//                largeImageURL: "https://cdn.myanimelist.net/images/anime/1996/147601l.jpg"
//            )
//        ),
//        titles: [
//            AnimeTitle(type: "Default", title: "Shangri-La Frontier: Kusoge Hunter, Kamige ni Idoman to su 2nd Season"),
//            AnimeTitle(type: "Synonym", title: "Shangri-La Frontier: Crappy Game Hunter Challenges God-Tier Game"),
//            AnimeTitle(type: "Synonym", title: "Shanfro"),
//            AnimeTitle(type: "Japanese", title: "シャングリラ・フロンティア～クソゲーハンター、神ゲーに挑まんとす～ 2nd season"),
//            AnimeTitle(type: "English", title: "Shangri-La Frontier Season 2")
//        ],
//        score: 8.29,
//        scoredBy: nil,
//        favorites: nil,
//        genres: [
//            AnimeGenre(id: 1, name: "Action"),
//            AnimeGenre(id: 2, name: "Adventure"),
//            AnimeGenre(id: 10, name: "Fantasy")
//        ]
//    )
//])
//
//let mockAnimeEntity = mockAnimeResponseDTO.data.map { $0.toEntity() }
