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
| |minLength|Default: `0`|
| |maxLength|Default: `minLength + 10`|
|integer|enum| |
| |minimum|Default: `-2^31`|
| |maximum|Default: `2^31 - 1`|
| |exclusiveMinimum| |
| |exclusiveMaximum| |
| |multipleOf| |
|number|minimum|Default: `-2^31`|
| |maximum|Default: `2^31 - 1`|
| |multipleOf| |
