require 'json_api_test_helpers/version'

module JsonApiTestHelpers
  def json_response
    if response.body.present?
      parsed_json = JSON.parse response.body
      parsed_json.with_indifferent_access unless parsed_json.is_a? Array
    else
      raise 'Response body is empty'
    end
  end

  def json_api_record(record, attributes, relationships: nil, additional: nil)
    json = {
      'data' => {
        'id' => record.id.to_s,
        'attributes' => json_api_record_attributes(record, attributes)
      }
    }
    json['data']['relationships'] = json_api_relationships(record, relationships) if relationships
    json
  end

  def json_api_collection(collection, attributes = nil, relationships: nil)
    {
      'data' => collection.map do |record|
        hash = {
          'id' => record.id.to_s
        }
        hash['attributes'] = json_api_record_attributes(record, attributes) if attributes
        hash['relationships'] = json_api_relationships(record, relationships) if relationships
        hash
      end
    }
  end

  def fix_value_for_json(value)
    return value.iso8601 if value.class.in? [DateTime, ActiveSupport::TimeWithZone]
    return value if value.is_a? Integer
    return value.serializable_hash if value.is_a? CarrierWave::Uploader::Serialization
    return value.reduce({}) do |hash, k_v|
      if k_v[1].is_a? Hash
        k_v[1] = k_v[1].reduce({}) do |value_hash, value_k_v|
          value_hash.merge! value_k_v[0].gsub('_', '-') => value_k_v[1]
        end
      end
      hash.merge! k_v[0].gsub('_', '-') => k_v[1]    
    end if value.is_a? Hash
    value.to_s
  end

  def fix_comparing_types(value)
    if value.class.in? [DateTime, ActiveSupport::TimeWithZone]
      value.to_datetime.utc.to_s
    elsif value.class == ActiveRecord::Point
      "#{value.x}, #{value.y}"
    else
      value
    end
  end

  def attributes_for_nested(attributes, **associations)
    associations.reduce(attributes) do |attr_hash, collection|
      attr_hash.merge! "#{collection[0]}_attributes" => (collection[1].each_with_index.reduce({}) do |hash, item|
        hash.merge! item.last.to_s => item.first
      end)
    end
  end

  private

  def json_api_record_attributes(record, attributes)
    attributes.reduce({}) do |hash, attr|
      hash.merge! attr[0].to_s.tr('_', '-') => fix_value_for_json(record.send(attr[0]))
    end
  end

  def json_api_relationships(record, relationships)
    relationships.reduce({}) do |hash, relationship|
      object = record.send relationship
      data = if object.is_a?(ActiveRecord::Associations::CollectionProxy)
               object.reduce([]) { |result, item| result << data_relationship_object(item, relationship) }
             else
               object.present? ? data_relationship_object(object, relationship) : {}
             end
      hash.merge! json_api_model_name(relationship) => { 'data' => data }
    end
  end

  def json_api_model_name(model_name)
    model_name.to_s.tr '_', '-'
  end

  def data_relationship_object(object, relationship)
    {
      'id' => object.id.to_s,
      'type' => json_api_model_name(relationship).pluralize
    }
  end
end
