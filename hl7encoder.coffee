_ = require 'underscore'
_s = require 'underscore.string'


module.exports = class Hl7Encoder

    FIELD_SEPARATOR = '|'
    COMPONENT_SEPARATOR = '^'

    encode: (message)->

        segments = @_encodeAllObjectPropertiesAsSegments message
        encodedMessage = segments.join('\n')

        return encodedMessage

    _encodeAllObjectPropertiesAsSegments: (object)->
        for own segmentName,value of object
            @encodeSegment segmentName,value

    encodeSegment: (name,segment)->

        result = name

        fields = _extractAllNumberedPropertiesIntoSparseArray segment

        for fieldIndex in [1..fields.length-1]
            
            fieldValue = fields[fieldIndex]

            result += FIELD_SEPARATOR
            result += @encodeField fieldValue

        return result

    _extractAllNumberedPropertiesIntoSparseArray = (object)->

        PROPERTY_PREFIX = '_'

        fields = []

        for own field,value of object
            continue unless _s.startsWith field, PROPERTY_PREFIX
            
            fieldNo = field.slice(1)
            fields[fieldNo] = value

        return fields

    encodeField: (value)->

        return '' unless value
        
        if _.isArray value
            value.join(COMPONENT_SEPARATOR)
        else
            value