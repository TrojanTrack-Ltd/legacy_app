/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the TrojanTrackModel type in your schema. */
@immutable
class TrojanTrackModel extends Model {
  static const classType = const _TrojanTrackModelModelType();
  final String id;
  final String? _horseName;
  final String? _sireName;
  final String? _damName;
  final List<String>? _videosJson;
  final String? _preview;
  final String? _yearofBirth;
  final String? _userId;
  final String? _userName;
  final String? _adminFiled;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TrojanTrackModelModelIdentifier get modelIdentifier {
      return TrojanTrackModelModelIdentifier(
        id: id
      );
  }
  
  String? get horseName {
    return _horseName;
  }
  
  String? get sireName {
    return _sireName;
  }
  
  String? get damName {
    return _damName;
  }
  
  List<String>? get videosJson {
    return _videosJson;
  }
  
  String? get preview {
    return _preview;
  }
  
  String? get yearofBirth {
    return _yearofBirth;
  }
  
  String? get userId {
    return _userId;
  }
  
  String? get userName {
    return _userName;
  }
  
  String? get adminFiled {
    return _adminFiled;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const TrojanTrackModel._internal({required this.id, horseName, sireName, damName, videosJson, preview, yearofBirth, userId, userName, adminFiled, createdAt, updatedAt}): _horseName = horseName, _sireName = sireName, _damName = damName, _videosJson = videosJson, _preview = preview, _yearofBirth = yearofBirth, _userId = userId, _userName = userName, _adminFiled = adminFiled, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory TrojanTrackModel({String? id, String? horseName, String? sireName, String? damName, List<String>? videosJson, String? preview, String? yearofBirth, String? userId, String? userName, String? adminFiled}) {
    return TrojanTrackModel._internal(
      id: id == null ? UUID.getUUID() : id,
      horseName: horseName,
      sireName: sireName,
      damName: damName,
      videosJson: videosJson != null ? List<String>.unmodifiable(videosJson) : videosJson,
      preview: preview,
      yearofBirth: yearofBirth,
      userId: userId,
      userName: userName,
      adminFiled: adminFiled);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrojanTrackModel &&
      id == other.id &&
      _horseName == other._horseName &&
      _sireName == other._sireName &&
      _damName == other._damName &&
      DeepCollectionEquality().equals(_videosJson, other._videosJson) &&
      _preview == other._preview &&
      _yearofBirth == other._yearofBirth &&
      _userId == other._userId &&
      _userName == other._userName &&
      _adminFiled == other._adminFiled;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TrojanTrackModel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("horseName=" + "$_horseName" + ", ");
    buffer.write("sireName=" + "$_sireName" + ", ");
    buffer.write("damName=" + "$_damName" + ", ");
    buffer.write("videosJson=" + (_videosJson != null ? _videosJson!.toString() : "null") + ", ");
    buffer.write("preview=" + "$_preview" + ", ");
    buffer.write("yearofBirth=" + "$_yearofBirth" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("userName=" + "$_userName" + ", ");
    buffer.write("adminFiled=" + "$_adminFiled" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TrojanTrackModel copyWith({String? horseName, String? sireName, String? damName, List<String>? videosJson, String? preview, String? yearofBirth, String? userId, String? userName, String? adminFiled}) {
    return TrojanTrackModel._internal(
      id: id,
      horseName: horseName ?? this.horseName,
      sireName: sireName ?? this.sireName,
      damName: damName ?? this.damName,
      videosJson: videosJson ?? this.videosJson,
      preview: preview ?? this.preview,
      yearofBirth: yearofBirth ?? this.yearofBirth,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      adminFiled: adminFiled ?? this.adminFiled);
  }
  
  TrojanTrackModel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _horseName = json['horseName'],
      _sireName = json['sireName'],
      _damName = json['damName'],
      _videosJson = json['videosJson']?.cast<String>(),
      _preview = json['preview'],
      _yearofBirth = json['yearofBirth'],
      _userId = json['userId'],
      _userName = json['userName'],
      _adminFiled = json['adminFiled'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'horseName': _horseName, 'sireName': _sireName, 'damName': _damName, 'videosJson': _videosJson, 'preview': _preview, 'yearofBirth': _yearofBirth, 'userId': _userId, 'userName': _userName, 'adminFiled': _adminFiled, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'horseName': _horseName, 'sireName': _sireName, 'damName': _damName, 'videosJson': _videosJson, 'preview': _preview, 'yearofBirth': _yearofBirth, 'userId': _userId, 'userName': _userName, 'adminFiled': _adminFiled, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<TrojanTrackModelModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<TrojanTrackModelModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField HORSENAME = QueryField(fieldName: "horseName");
  static final QueryField SIRENAME = QueryField(fieldName: "sireName");
  static final QueryField DAMNAME = QueryField(fieldName: "damName");
  static final QueryField VIDEOSJSON = QueryField(fieldName: "videosJson");
  static final QueryField PREVIEW = QueryField(fieldName: "preview");
  static final QueryField YEAROFBIRTH = QueryField(fieldName: "yearofBirth");
  static final QueryField USERID = QueryField(fieldName: "userId");
  static final QueryField USERNAME = QueryField(fieldName: "userName");
  static final QueryField ADMINFILED = QueryField(fieldName: "adminFiled");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TrojanTrackModel";
    modelSchemaDefinition.pluralName = "TrojanTrackModels";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.HORSENAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.SIRENAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.DAMNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.VIDEOSJSON,
      isRequired: false,
      isArray: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.collection, ofModelName: describeEnum(ModelFieldTypeEnum.string))
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.PREVIEW,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.YEAROFBIRTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.USERNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TrojanTrackModel.ADMINFILED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _TrojanTrackModelModelType extends ModelType<TrojanTrackModel> {
  const _TrojanTrackModelModelType();
  
  @override
  TrojanTrackModel fromJson(Map<String, dynamic> jsonData) {
    return TrojanTrackModel.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'TrojanTrackModel';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [TrojanTrackModel] in your schema.
 */
@immutable
class TrojanTrackModelModelIdentifier implements ModelIdentifier<TrojanTrackModel> {
  final String id;

  /** Create an instance of TrojanTrackModelModelIdentifier using [id] the primary key. */
  const TrojanTrackModelModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'TrojanTrackModelModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TrojanTrackModelModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}