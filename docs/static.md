# Static

Static value generation rule

|Type|Property|Rule|
|---|---|---|
|complex|oneOf|first item|
| |anyOf|same as allOf|
|array|N/A|size is `1`|
| |minItems|size is minItems|
|string|N/A|`string`|
| |enum|first item|
| |pattern|Generated but always the same|
| |format=uri|`https://some.uri`|
| |format=uuid|`11111111-1111-1111-1111-111111111111`|
| |format=guid|`11111111-1111-1111-1111-111111111111`|
| |format=email|`some@email.com`|
| |format=date|today|
| |format=date-time|midnight today|
| |minLength|`1` repeats for (minLength + 10) times if no maxLength specified|
| |maxLength|`1` repeats for maxLength times|
|integer|N/A|`1`|
| |enum|first item|
| |minimum|minimum|
| |exclusiveMinimum|minimum + 1|
| |multipleOf|minimum value meets multipleOf condition|
|number|N/A|0.0|
| |minimum|minimum rounded to 2 decimal places|
| |multipleOf|minimum value meets multipleOf condition|
