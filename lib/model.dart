class TopData {
  final List<MainStickyMenu> mainStickyMenu;
  final String status;
  final String message;

  TopData({
    required this.mainStickyMenu,
    required this.status,
    required this.message,
  });

  factory TopData.fromJson(Map<String, dynamic> json) {
    final mainStickyMenuList = json['main_sticky_menu'] as List?;
    return TopData(
      mainStickyMenu: mainStickyMenuList != null
          ? mainStickyMenuList.map((e) => MainStickyMenu.fromJson(e)).toList()
          : [],
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

class MainStickyMenu {
  final String title;
  final String image;
  final String sortOrder;
  final List<SliderImage> sliderImages;

  MainStickyMenu({
    required this.title,
    required this.image,
    required this.sortOrder,
    required this.sliderImages,
  });

  factory MainStickyMenu.fromJson(Map<String, dynamic> json) {
    final sliderImagesList = json['slider_images'] as List?;
    return MainStickyMenu(
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      sortOrder: json['sort_order']?.toString() ?? '',
      sliderImages: sliderImagesList != null
          ? sliderImagesList.map((e) => SliderImage.fromJson(e)).toList()
          : [],
    );
  }
}

class SliderImage {
  final String title;
  final String image;
  final String sortOrder;
  final String cta;

  SliderImage({
    required this.title,
    required this.image,
    required this.sortOrder,
    required this.cta,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) {
    return SliderImage(
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      sortOrder: json['sort_order']?.toString() ?? '',
      cta: json['cta']?.toString() ?? '',
    );
  }
}



class MiddleData {
  final List<MiddleSection> shopByCategory;
  final List<MiddleSection> shopByFabric;
  final List<MiddleSection> unstitched;
  final List<MiddleSection> boutiqueCollection;

  MiddleData({
    required this.shopByCategory,
    required this.shopByFabric,
    required this.unstitched,
    required this.boutiqueCollection,
  });

  factory MiddleData.fromJson(Map<String, dynamic> json) {
    return MiddleData(
      shopByCategory: (json['shop_by_category'] as List?)
          ?.map((e) => MiddleSection.fromJson(e))
          .toList() ?? [],
      shopByFabric: (json['shop_by_fabric'] as List?)
          ?.map((e) => MiddleSection.fromJson(e))
          .toList() ?? [],
      unstitched: (json['Unstitched'] as List?)
          ?.map((e) => MiddleSection.fromJson(e))
          .toList() ?? [],
      boutiqueCollection: (json['boutique_collection'] as List?)
          ?.map((e) => MiddleSection.fromJson(e))
          .toList() ?? [],
    );
  }
}

class MiddleSection {
  final String productId;
  final String name;
  final String image;

  MiddleSection({
    required this.productId,
    required this.name,
    required this.image,
  });

  factory MiddleSection.fromJson(Map<String, dynamic> json) {
    return MiddleSection(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class BottomData {
  final List<Pattern> rangeOfPattern;
  final List<DesignOccasion> designOccasion;
  final String status;
  final String message;

  BottomData({
    required this.rangeOfPattern,
    required this.designOccasion,
    required this.status,
    required this.message,
  });

  factory BottomData.fromJson(Map<String, dynamic> json) {
    return BottomData(
      rangeOfPattern: (json['range_of_pattern'] as List?)
          ?.map((e) => Pattern.fromJson(e))
          .toList() ?? [],
      designOccasion: (json['design_occasion'] as List?)
          ?.map((e) => DesignOccasion.fromJson(e))
          .toList() ?? [],
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

class Pattern {
  final String productId;
  final String image;
  final String name;

  Pattern({
    required this.productId,
    required this.image,
    required this.name,
  });

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      productId: json['product_id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class DesignOccasion {
  final String productId;
  final String name;
  final String image;
  final String subName;
  final String cta;

  DesignOccasion({
    required this.productId,
    required this.name,
    required this.image,
    required this.subName,
    required this.cta,
  });

  factory DesignOccasion.fromJson(Map<String, dynamic> json) {
    return DesignOccasion(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      subName: json['sub_name']?.toString() ?? '',
      cta: json['cta']?.toString() ?? '',
    );
  }
}

class CategoryData {
  final List<Category> categories;
  final String bannerImage;
  final String status;
  final String message;

  CategoryData({
    required this.categories,
    required this.bannerImage,
    required this.status,
    required this.message,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories: (json['categories'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList() ?? [],
      bannerImage: json['banner_image']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

class Category {
  final String categoryId;
  final String categoryName;
  final String parentId;
  final List<Category> children;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.parentId,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      parentId: json['parent_id']?.toString() ?? '',
      children: (json['child'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList() ?? [],
    );
  }
}