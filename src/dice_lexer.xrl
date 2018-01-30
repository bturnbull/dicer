Definitions.

Whitespace = [\s\t]
Terminator = \n|\r\n|\r

Digit = [0-9]
NonZeroDigit = [1-9]
Sign = [\+\-]

Integer = {NonZeroDigit}{Digit}*
SingleDice = d{Integer}
MultiDice = {Integer}d{Integer}
Operator = {Sign}

Rules.

{Whitespace} : skip_token.
{Terminator} : skip_token.
{SingleDice} : {token, {dice, TokenLine, list_to_binary(lists:concat(['1', TokenChars]))}}.
{SingleDice}a : {token, {dice_advantage, TokenLine, list_to_binary(lists:concat(['1', lists:droplast(TokenChars)]))}}.
{SingleDice}d : {token, {dice_disadvantage, TokenLine, list_to_binary(lists:concat(['1', lists:droplast(TokenChars)]))}}.
{MultiDice} : {token, {dice, TokenLine, list_to_binary(TokenChars)}}.
{MultiDice}a : {token, {dice_advantage, TokenLine, list_to_binary(lists:droplast(TokenChars))}}.
{MultiDice}d : {token, {dice_disadvantage, TokenLine, list_to_binary(lists:droplast(TokenChars))}}.
{Operator} : {token, {op, TokenLine, list_to_binary(TokenChars)}}.
{Integer} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.

Erlang code.
