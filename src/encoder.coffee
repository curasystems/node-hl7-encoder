_ = require 'underscore'
_s = require 'underscore.string'


module.exports = class Hl7Encoder

    FIELD_SEPARATOR = '|'
    COMPONENT_SEPARATOR = '^'
    NEW_LINE = '\n'

    DEFAULT_SEPARATORS = "#{COMPONENT_SEPARATOR}~\\&"

    encode: (message)->

        segments = @_encodeAllObjectPropertiesAsSegments message
        encodedMessage = segments.join NEW_LINE

        return encodedMessage

    _encodeAllObjectPropertiesAsSegments: (object)->
        for own segmentName,value of object
            @encodeSegment segmentName,value

    encodeSegment: (name,segment)->

        if name is 'MSH'
            segment._1 = DEFAULT_SEPARATORS unless segment._1

        fields = @_extractAllNumberedPropertiesIntoSparseArray segment
        segment = name + @_joinAllFieldsInSparseArrayIntoASingleLine fields
        
        return segment

    _extractAllNumberedPropertiesIntoSparseArray: (object)->

        PROPERTY_PREFIX = '_'

        fields = []

        for own field,value of object
            continue unless _s.startsWith field, PROPERTY_PREFIX
            
            fieldNo = field.slice(1)
            fields[fieldNo] = value

        return fields

    _joinAllFieldsInSparseArrayIntoASingleLine: (fields)->

        result = ''

        return result if fields.length < 2

        for fieldIndex in [1..fields.length-1] 
            fieldValue = fields[fieldIndex]

            result += FIELD_SEPARATOR
            result += @encodeField fieldValue

        return result

    encodeField: (value)->

        return '' unless value
        
        if _.isArray value
            value.join COMPONENT_SEPARATOR
        else
            value