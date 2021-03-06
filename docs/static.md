# Static

Static value generation rule

|Type|Property|Rule|
|---|---|---|
|complex|oneOf|first item|
| |anyOf|same as allOf|
|boolean|N/A|`true`|
|array|N/A|size is `1`|
| |minItems|size is max(minItems,1)|
|string|N/A|`string`|
| |enum|first item|
| |pattern|Generated but always the same|
| |format=uri|`https://some.uri`|
| |format=uuid|`11111111-1111-1111-1111-111111111111`|
| |format=guid|`11111111-1111-1111-1111-111111111111`|
| |format=email|`some@email.com`|
| |format=date|today|
| |format=date-time|midnight today|
| |format=binary|`binary`|
| |format=byte|`Ynl0ZQ==`|
| |minLength|`1` repeats for (minLength + 10) times if no maxLength specified|
| |maxLength|`1` repeats for maxLength times|
|integer|N/A|`2^31 - 1`|
| |enum|first item|
| |maximum|maximum|
| |exclusiveMaximum|maximum - 1|
| |multipleOf|maximum value meets multipleOf condition|
| |format=int32|`2^31 - 1`|
| |format=int64|`2^63 - 1`|
|number|N/A|`2^31 - 1`|
| |maximum|maximum rounded to 2 decimal places|
| |multipleOf|maximum value meets multipleOf condition|
