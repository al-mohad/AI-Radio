import 'dart:convert';

import 'package:collection/collection.dart';

class MYRadio {
  final int id;
  final int order;
  final String name;
  final String tagline;
  final String color;
  final String des;
  final String url;
  final String category;
  final String icon;
  final String image;
  final String lang;
  MYRadio({
    this.id,
    this.order,
    this.name,
    this.tagline,
    this.color,
    this.des,
    this.url,
    this.category,
    this.icon,
    this.image,
    this.lang,
  });

  MYRadio copyWith({
    int id,
    int order,
    String name,
    String tagline,
    String color,
    String des,
    String url,
    String category,
    String icon,
    String image,
    String lang,
  }) {
    return MYRadio(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      color: color ?? this.color,
      des: des ?? this.des,
      url: url ?? this.url,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      lang: lang ?? this.lang,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order,
      'name': name,
      'tagline': tagline,
      'color': color,
      'des': des,
      'url': url,
      'category': category,
      'icon': icon,
      'image': image,
      'lang': lang,
    };
  }

  factory MYRadio.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MYRadio(
      id: map['id'],
      order: map['order'],
      name: map['name'],
      tagline: map['tagline'],
      color: map['color'],
      des: map['des'],
      url: map['url'],
      category: map['category'],
      icon: map['icon'],
      image: map['image'],
      lang: map['lang'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MYRadio.fromJson(String source) =>
      MYRadio.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MYRadio(id: $id, order: $order, name: $name, tagline: $tagline, color: $color, des: $des, url: $url, category: $category, icon: $icon, image: $image, lang: $lang)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MYRadio &&
        o.id == id &&
        o.order == order &&
        o.name == name &&
        o.tagline == tagline &&
        o.color == color &&
        o.des == des &&
        o.url == url &&
        o.category == category &&
        o.icon == icon &&
        o.image == image &&
        o.lang == lang;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        name.hashCode ^
        tagline.hashCode ^
        color.hashCode ^
        des.hashCode ^
        url.hashCode ^
        category.hashCode ^
        icon.hashCode ^
        image.hashCode ^
        lang.hashCode;
  }
}

class MYRadioList {
  final List<MYRadio> radios;
  MYRadioList({
    this.radios,
  });

  MYRadioList copyWith({
    List<MYRadio> radios,
  }) {
    return MYRadioList(
      radios: radios ?? this.radios,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'radios': radios?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory MYRadioList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MYRadioList(
      radios: List<MYRadio>.from(map['radios']?.map((x) => MYRadio.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MYRadioList.fromJson(String source) =>
      MYRadioList.fromMap(json.decode(source));

  @override
  String toString() => 'RadioList(radios: $radios)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is MYRadioList && listEquals(o.radios, radios);
  }

  @override
  int get hashCode => radios.hashCode;
}
