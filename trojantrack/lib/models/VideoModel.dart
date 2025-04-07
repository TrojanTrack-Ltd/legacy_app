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
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the VideoModel type in your schema. */
@immutable
class VideoModel {
  final String id;
  final String? _recordedStatus;
  final String? _videoUrl;
  final String? _videoThumbnail;
  final TemporalDateTime? _createdDate;
  final String? _comment;

  String? get recordedStatus {
    return _recordedStatus;
  }
  
  String? get videoUrl {
    return _videoUrl;
  }
  
  String? get videoThumbnail {
    return _videoThumbnail;
  }
  
  TemporalDateTime? get createdDate {
    return _createdDate;
  }
  
  String? get comment {
    return _comment;
  }
  
  const VideoModel._internal({required this.id, recordedStatus, videoUrl, videoThumbnail, createdDate, comment}): _recordedStatus = recordedStatus, _videoUrl = videoUrl, _videoThumbnail = videoThumbnail, _createdDate = createdDate, _comment = comment;
  
  factory VideoModel({String? id, String? recordedStatus, String? videoUrl, String? videoThumbnail, TemporalDateTime? createdDate, String? comment}) {
    return VideoModel._internal(
      id: id == null ? UUID.getUUID() : id,
      recordedStatus: recordedStatus,
      videoUrl: videoUrl,
      videoThumbnail: videoThumbnail,
      createdDate: createdDate,
      comment: comment);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoModel &&
      id == other.id &&
      _recordedStatus == other._recordedStatus &&
      _videoUrl == other._videoUrl &&
      _videoThumbnail == other._videoThumbnail &&
      _createdDate == other._createdDate &&
      _comment == other._comment;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("VideoModel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("recordedStatus=" + "$_recordedStatus" + ", ");
    buffer.write("videoUrl=" + "$_videoUrl" + ", ");
    buffer.write("videoThumbnail=" + "$_videoThumbnail" + ", ");
    buffer.write("createdDate=" + (_createdDate != null ? _createdDate!.format() : "null") + ", ");
    buffer.write("comment=" + "$_comment");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  VideoModel copyWith({String? id, String? recordedStatus, String? videoUrl, String? videoThumbnail, TemporalDateTime? createdDate, String? comment}) {
    return VideoModel._internal(
      id: id ?? this.id,
      recordedStatus: recordedStatus ?? this.recordedStatus,
      videoUrl: videoUrl ?? this.videoUrl,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      createdDate: createdDate ?? this.createdDate,
      comment: comment ?? this.comment);
  }
  
  VideoModel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _recordedStatus = json['recordedStatus'],
      _videoUrl = json['videoUrl'],
      _videoThumbnail = json['videoThumbnail'],
      _createdDate = json['createdDate'] != null ? TemporalDateTime.fromString(json['createdDate']) : null,
      _comment = json['comment'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'recordedStatus': _recordedStatus, 'videoUrl': _videoUrl, 'videoThumbnail': _videoThumbnail, 'createdDate': _createdDate?.format(), 'comment': _comment
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'recordedStatus': _recordedStatus, 'videoUrl': _videoUrl, 'videoThumbnail': _videoThumbnail, 'createdDate': _createdDate, 'comment': _comment
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "VideoModel";
    modelSchemaDefinition.pluralName = "VideoModels";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'id',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'recordedStatus',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'videoUrl',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'videoThumbnail',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'createdDate',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'comment',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}