module Lexer where

import Prelude

import Control.Alt ((<|>))
import Data.CodePoint.Unicode (isLetter)
import Data.Eq.Generic (genericEq)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Parsing (Parser, ParserT)
import Parsing.String (char, string)
import Parsing.String.Basic (number, takeWhile1)

data Token
  = Illegal
  | Eof
  | Ident String
  | Int Number
  | Equal
  | Plus
  | Comma
  | Semicolon
  | LParen
  | RParen
  | LSquirly
  | RSquirly
  | Function
  | Let

derive instance genericToken :: Generic Token _

instance showToken :: Show Token where
  show = genericShow

instance eqToken :: Eq Token where
  eq = genericEq

letP :: forall a. ParserT String a Token
letP = (\_ -> Let) <$> (string "let")

intP :: forall a. ParserT String a Token
intP = Int <$> number

equalP :: forall a. ParserT String a Token
equalP = (\_ -> Equal) <$> (string "=")

identP :: forall a. ParserT String a Token
identP = Ident <$> takeWhile1 isLetter

semiColonP :: forall a. ParserT String a Token
semiColonP = (\_ -> Semicolon) <$> char ';'

fnP :: forall a. ParserT String a Token
fnP = (\_ -> Function) <$> string "fn"

plusP :: forall a. ParserT String a Token
plusP = (\_ -> Plus) <$> char '+'

commaP :: forall a. ParserT String a Token
commaP = (\_ -> Comma) <$> char ','

lParenP :: forall a. ParserT String a Token
lParenP = (\_ -> LParen) <$> char '('

rParenP :: forall a. ParserT String a Token
rParenP = (\_ -> RParen) <$> char ')'

lSquirlyP :: forall a. ParserT String a Token
lSquirlyP = (\_ -> LSquirly) <$> char '{'

rSquirlyP :: forall a. ParserT String a Token
rSquirlyP = (\_ -> RSquirly) <$> char '}'

token :: forall a. ParserT String a Token
token =
  letP
    <|> intP
    <|> equalP
    <|> identP
    <|> semiColonP
    <|> fnP
    <|> plusP
    <|> commaP
    <|> lParenP
    <|> rParenP
    <|> lSquirlyP
    <|> rSquirlyP

parser :: Parser String Token
parser = token
