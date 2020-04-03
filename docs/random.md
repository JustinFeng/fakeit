# Random

The following Openapi properties are supported in random response generation

|Type|Property|Notes|
|---|---|---|
|complex|oneOf| |
| |allOf| |
| |anyOf| |
|array|uniqueItems|Try to generate unique random items, but will give up after exceeding retry limits|
| |minItems|Default: `1`|
| |maxItems|Default: `minItems + 2`|
|string|enum| |
| |pattern| |
| |format=uri| |
| |format=uuid| |
| |format=guid| |
| |format=email| |
| |format=date|In past 100 days|
| |format=date-time|In past 100 days|
| |format=binary|UTF-8 string with length 1 ~ 100|
| |minLength|Default: `0`|
| |maxLength|Default: `minLength + 10`|
|integer|enum| |
| |minimum|Default: based on format|
| |maximum|Default: based on format|
| |exclusiveMinimum| |
| |exclusiveMaximum| |
| |multipleOf| |
| |format=int32|`-2^31` ~ `2^31 - 1`|
| |format=int64|`-2^63` ~ `2^63 - 1`|
|number|minimum|Default: `-2^31`|
| |maximum|Default: `2^31 - 1`|
| |multipleOf| |
