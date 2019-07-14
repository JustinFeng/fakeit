# Random

The following Openapi properties are supported in random response generation

|Type|Property|Notes|
|---|---|---|
|complex|oneOf| |
| |allOf| |
| |anyOf| |
|array|uniqueItems|Try to generate unique random items, but will give up after exceeding retry limits|
| |minItems|Default: `1`|
| |maxItems|Default: `3`|
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
| |minimum|Default: `1`|
| |maximum|Default: `2^32`|
| |exclusiveMinimum| |
| |exclusiveMaximum| |
| |multipleOf| |
|number|minimum|Default: `0.0`|
| |maximum|Default: `2^32`|
| |multipleOf| |
