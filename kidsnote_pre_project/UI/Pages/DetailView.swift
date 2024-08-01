//
//  DetailView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 8/1/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DetailViewModel
    @State var showWebview = false
    @State var urlToLoad: String = ""
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("도서 정보")
                        .font(.title)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .frame(height: 58)
            }
            ScrollView {
                DetailTopArea(viewModel: viewModel, info: viewModel.bookInfo)
                DetailMidArea(viewModel: viewModel, info: viewModel.bookInfo)
                if let rating = viewModel.bookInfo.stars, let reviews = viewModel.bookInfo.reviews {
                    DetailMidRatingArea(viewModel: viewModel, rating: rating, reviews: reviews)
                        .padding(.bottom, 24)
                }
                DetailBottomArea(viewModel: viewModel, info: viewModel.bookInfo)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showWebview) {
            SafariView(urlString: urlToLoad)
        }
        .onReceive(viewModel.$loadWebUrl) { url in
            guard let url, !url.isEmpty else { return }
            urlToLoad = url
            showWebview = true
        }
    }
}

private struct DetailTopArea: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var info: SearchViewModel.BookInfo
    @ObservedObject var imageViewModel: ImageViewModel
    
    init(viewModel: DetailViewModel, info: SearchViewModel.BookInfo) {
        self.viewModel = viewModel
        self.info = info
        self.imageViewModel = ImageViewModel(urlString: info.thumbnailUrl)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if let image = imageViewModel.image {
                ImageView(viewModel: imageViewModel, image: image)
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(info.title)
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                if !info.authors.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(info.authors, id: \.self) { author in
                            Text(author)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                HStack(spacing: 0) {
                    Text(info.type)
                        .font(.body)
                        .foregroundColor(.secondary)
                    if info.type.lowercased() != "eBook".lowercased() {
                        Text(" · ")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("\(info.pages) 페이지")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onAppear {
            imageViewModel.load()
        }
    }
}

private struct DetailMidArea: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: DetailViewModel
    @State var info: SearchViewModel.BookInfo
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
            HStack(spacing: 0) {
                Button {
                    Logger.log("무료 샘플")
                    viewModel.freeSampleButtonPressed.send()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(height: 50)
                            .cornerRadius(5)
                        Text("무료 샘플")
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    }
                }
                Spacer()
                    .frame(width: 16)
                Button {
                    Logger.log("전체 도서 구매하기")
                    viewModel.buyButtonPressed.send()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(.gray, lineWidth: 1)
                            .foregroundColor(.clear)
                            .frame(height: 50)
                        Text("전체 도서 구매하기")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}

private struct DetailMidRatingArea: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var rating: Double
    @State var reviews: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("\(rating, specifier: "%.1f")")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.trailing, 8)
                RatingView(rating: rating, maxRating: 5)
                    .frame(height: 20)
                Spacer()
            }
            Text("Google Play 평점 \(reviews) 개")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
    }
}

private struct DetailBottomArea: View {
    @ObservedObject var viewModel: DetailViewModel
    @State var info: SearchViewModel.BookInfo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(info.title)
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.bottom, 24)
            Text(info.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 24)
            HStack {
                Text("게시일")
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.bottom, 24)
            HStack(spacing: 0) {
                Text(info.publishedDate)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(" · ")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(info.publisher)
                    .font(.body)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let description =
"""
\\u003c책 소개\\u003e #현대물 #오래된연인 #애증 #배신 #오해/착각 #연예계 #달달물 #사건물 #상처공 #다정공 #순진공 #후회공 #미인수 #순정수 #외유내강수 #상처수 기획사 프로듀서인 현석과 낮에는 마트에서 일하며 밤에는 클럽의 춤꾼으로 유명한 진영. 두 사람은 오랜 세월을 사랑과 애정으로 함께해 온 사이다. 그러나 어느 날 갑자기 언론에서 쏟아져나오는 현석의 열애설에 진영은 당혹스럽기만 하다. 그러나 현석은 진영을 만나려 하지 않고, 그저 언론 기사들을 믿으라고 매몰차게 이야기한다. 억울함과 분노에 현석의 회사를 찾아간 진영은 그가 새로운 연인과 대화하는 것을 엿듣고, 현석의 변심에 사연이 있음을 눈치챈다. 오랜 세월을 함께해 온 연인. 그러나 갑작스럽게, 그것도 언론을 통해서 이뤄진 이별 통보. 그리고 잃어버린 사랑을 되찾기 위한 고군분투. 도시형 로맨스의 정석을 보여주는 단편. 시간과 비용은 줄이고, 재미는 높여서 스낵처럼 즐기는 BL - 한뼘 BL 컬렉션. \\u003c저자 소개\\u003e 만자 인생 미늘, 언젠가 그런 날이 올지 모르겠지만, 필명인 미늘처럼 한번 걸리면 헤어나올 수 없는 멋진 작품을 쓰고 싶습니다. \\u003c목차\\u003e 표지 목차 1장. 망가지고 싶어 2장. 추억의 그 밤 3장. 널 놓아줄게 4장. 내가 사랑하는 사람은 시리즈 및 저자 소개 copyrights (참고) 분량: 약 3.8만자 (종이책 추정 분량: 약 75쪽) \\u003c미리 보기\\u003e 인터넷에 올라온 기사를 읽으며 현석이 왜 나와 이별을 선택했는지 확실히 깨달았다. '혜성처럼 나타난 가요계의 혜성 윤지민, 이번엔 J 엔터테인먼트 기획사 장현석 프로듀서와 핑크빛 열애 중?' 이라는 머리글 기사와 함께 두 사람이 팔짱을 끼고 다정하게 데이트하는 사진이 인터넷이며 연예 뉴스에 연이어 보도되기 시작했다. 나는 그 기사를 보자마자 그 기사가 진짜인지 현석을 찾아가 묻고 싶었다. 하지만 결국 핑크빛 열애 기사는 현실이 되었고, 두 사람이 열애 중이라는 말도 안 되는 일이 현석의 입을 통해서가 아니라 기사를 통해서 전해진 꼴이 되어버렸다. 그렇게 차갑게 말할 때부터 알아봤어야 했다. 뒤억의 그 밤 3장. 널 놓아줄게 4장. 내가 사랑하는 사람은 시리즈 및 저자 소개 copyrights (참고) 분량: 약 3.8만자 (종이책 추정 분량: 약 75쪽) \\u003c미리 보기\\u003e 인터넷에 올라온 기사를 읽으며 현석이 왜 나와 이별을 선택했는지 확실히 깨달았다. '혜성처럼 나타난 가요계의 혜성 윤지민, 이번엔 J 엔터테인먼트 기획사 장현석 프로듀서와 핑크빛 열애 중?' 이라는 머리글 기사와 함께 두 사람이 팔짱을 끼고 다정하게 데이트하는 사진이 인터넷이며 연예 뉴스에 연이어 보도되기 시작했다. 나는 그 기사를 보자마자 그 기사가 진짜인지 현석을 찾아가 묻고 싶었다. 하지만 결국 핑크빛 열애 기사는 현실이 되었고, 두 사람이 열애 중이라는 말도 안 되는 일이 현석의 입을 통해서가 아니라 기사를 통해서 전해진 꼴이 되어버렸다. 그렇게 차갑게 말할 때부터 알아봤어야 했다. 뒤\\353\\212늦은 후회가 밀려왔다. 그때 그의 표정에서 그의 진실을 읽어냈더라면 이렇게 비참한 기분은 들지 않았을 것이다. 다리에 힘이 풀렸다. 나에게 왜 이렇게 잔인하게 구냐고, 그래서 기획사에 한 번도 놀러 오라고 말하지 않았느냐고. 자괴감이 들었다. 문제의 그, 현석의 큐피트 윤지민 때문인가? 결국 현석은 지민을 나한테 보여주고 싶지 않았던 것이다. 어차피 우린 잠깐 만났다가 헤어질 사이라는 것을 알았을 테니까. 나는 윤지민이라는 놈을 잘 안다. 그가 연예계에서 얼마나 영향력을 행사하는 인물인지, 또한, 그가 사귀었다가 헤어진 놈이 얼마나 많은지, 그런데도 여전히 인기몰이 중인 그놈을 얼마나 많은 사람이 동경하고 우상시하는지도 잘 알고 있다. \"좀 만나자.\" 현석에게 전화를 걸었다. 현석은 못 받을 전화라도 받았다는 듯이 혀를 차며 차갑게 대꾸했다. [이억의 그 밤 3장. 널 놓아줄게 4장. 내가 사랑하는 사람은 시리즈 및 저자 소개 copyrights (참고) 분량: 약 3.8만자 (종이책 추정 분량: 약 75쪽) \\u003c미리 보기\\u003e 인터넷에 올라온 기사를 읽으며 현석이 왜 나와 이별을 선택했는지 확실히 깨달았다. '혜성처럼 나타난 가요계의 혜성 윤지민, 이번엔 J 엔터테인먼트 기획사 장현석 프로듀서와 핑크빛 열애 중?' 이라는 머리글 기사와 함께 두 사람이 팔짱을 끼고 다정하게 데이트하는 사진이 인터넷이며 연예 뉴스에 연이어 보도되기 시작했다. 나는 그 기사를 보자마자 그 기사가 진짜인지 현석을 찾아가 묻고 싶었다. 하지만 결국 핑크빛 열애 기사는 현실이 되었고, 두 사람이 열애 중이라는 말도 안 되는 일이 현석의 입을 통해서가 아니라 기사를 통해서 전해진 꼴이 되어버렸다. 그렇게 차갑게 말할 때부터 알아봤어야 했다. 뒤\\353\\212늦은 후회가 밀려왔다. 그때 그의 표정에서 그의 진실을 읽어냈더라면 이렇게 비참한 기분은 들지 않았을 것이다. 다리에 힘이 풀렸다. 나에게 왜 이렇게 잔인하게 구냐고, 그래서 기획사에 한 번도 놀러 오라고 말하지 않았느냐고. 자괴감이 들었다. 문제의 그, 현석의 큐피트 윤지민 때문인가? 결국 현석은 지민을 나한테 보여주고 싶지 않았던 것이다. 어차피 우린 잠깐 만났다가 헤어질 사이라는 것을 알았을 테니까. 나는 윤지민이라는 놈을 잘 안다. 그가 연예계에서 얼마나 영향력을 행사하는 인물인지, 또한, 그가 사귀었다가 헤어진 놈이 얼마나 많은지, 그런데도 여전히 인기몰이 중인 그놈을 얼마나 많은 사람이 동경하고 우상시하는지도 잘 알고 있다. \"좀 만나자.\" 현석에게 전화를 걸었다. 현석은 못 받을 전화라도 받았다는 듯이 혀를 차며 차갑게 대꾸했다. [이\\353런 사적인 전화는 내가 하지 말라고 했을 텐데?] \"내가 전화라도 안 하면 넌 나한테 해명조차 안 할 거잖아.\" 현석은 쓰다 달다 말 한마디가 없었다. \"그러니까 잠깐 만나자. 적어도 해명 정도는 해줘야지. 우리가 사귄 해가 몇 년인데. 우리가 자주 만나던 그 공터에서 보자. 너 퇴근할 때쯤 맞춰서 갈게.\" [바빠서 안 돼.] \"그래도 잠깐 봐. 우리 아직 할 말 남았잖아.\" [무슨 할 말? 인터넷으로 기사 봤을 거 아냐.] 이런 망할 자식 같으니라고! 순간 가슴 속에 꾹꾹 담아두었던 말들이 한꺼번에 쏟아져나왔다. \"야, 장현석. 너 혼자 마음 좀 편해 보자고 그딴 식으로 기사 내보내면 다야? 내가 할 말이 있어. 어쨌든 공터로 나와.\" [못 간다니까. 바쁘기도 하고 오늘 중요한 미팅도 있어.] \"좋아. 네가 그런 식으로 나온다면 나도 어쩔 수 없지. 내가 갈게. 내가 기획사에 찾아가면 퍽 좋겠다. 사람들 많은데 어떻게 내가 기획사로 찾아가? 그건 너도 싫잖아. 그러니까 그게 싫으면 공터로 나오던지.\" 나는 그 말만 하고 전화를 뚝 끊었다. 아마도 내 생각에 그는 나오지 않을 것이다. 내가 겪어본 그의 성격은 좋고 싫음이 확실했다. 차라리 그럴 바에는 내가 기획사로 찾아가는 것이 나을 성싶었다. \\u003c한뼘 BL 컬렉션 소개\\u003e 시간과 비용 부담을 확 줄여서, BL 초심자도 가볍게 읽는 컬렉션입니다. 내 취향이 무엇인지, 어떤 주인공에게 끌리는지, 다른 사람들은 뭘 읽고 좋아하는지 궁금하셨지만, 몇십만 자가 넘는 장편을 다 떼야 알 수 있다는 생각..... 이제는 걱정할 필요 없습니다. 가볍게 읽으면서 스낵처럼 즐기는 새로운 스타일의 BL들이 찾아 옵니다. 앞으로 나올 한뼘 BL 시리즈를 기대해 주세요. (참고) 한뼘 BL 컬렉션 내 번호는, 편의상의 부여된 것으로, 읽는 순서와 관련이 없습니다. 컬렉션 내 모든 작품이 그 자체로 완결됩니다. 출간 (예정) 목록 진실이 무엇이든_미늘 [로맨스] 구더기_미늘 [로맨스] 단죄의 시간_미늘 삵_미늘 성년식_닐리바 위의 도서 외 매달 10여종 이상을 발간하고 있습니다.
"""
    let info = SearchViewModel.BookInfo(
        id: "",
        thumbnailUrl: "http://books.google.com/books/content?id=TnSCCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
        authors: ["자청"],
        title: "역행자",
        type: "eBook",
        pages: 0,
        stars: 3.7,
        reviews: 10,
        description: description,
        publishedDate: "2020-01-20",
        publisher: "다산초당",
        previewLink: "http://books.google.co.kr/books?id=MwXLDwAAQBAJ&printsec=frontcover&dq=%EB%82%B4%EA%B0%80&hl=&as_brr=5&cd=2&source=gbs_api",
        buyLink: "https://play.google.com/store/books/details?id=MwXLDwAAQBAJ&rdid=book-MwXLDwAAQBAJ&rdot=1&source=gbs_api"
    )
    return DetailView(viewModel: DetailViewModel(info: info))
        .preferredColorScheme(.dark)
}
