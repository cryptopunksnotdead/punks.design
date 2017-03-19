module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.program
        { init = createModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


-- TYPES

type alias Card =
    { id      : Int
    , group   : Group
    , flipped : Bool
    }

type alias Deck =
    List Card

type Group
    = A
    | B

type Model
    = Playing Deck


type Msg
    = NoOp
    | Flip Card



-- MODEL

createDeck : Deck
createDeck = [
     (Card 1 A True),
     (Card 3 A False),
     (Card 5 B False),
     (Card 6 A False),
     (Card 6 B True),
     (Card 5 A True),
     (Card 8 B False),
     (Card 7 A False),
     (Card 8 A False),
     (Card 4 A False),
     (Card 2 B False),
     (Card 3 B True),
     (Card 2 A False),
     (Card 1 B False),
     (Card 4 B False),
     (Card 7 B False)
   ]

createModel : ( Model, Cmd Msg )
createModel =
    ( Playing createDeck, Cmd.none )


-- UPDATE


flip : Card -> Card -> Card
flip a b =
    if (a.id == b.id) && (a.group == b.group) then
        { b | flipped = not b.flipped }
    else
        b




update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Flip card ->
            case model of
                Playing deck ->
                    let
                        newDeck =
                            List.map (flip card) deck
                    in
                        Playing newDeck ! []



-- VIEW

cardBackText card =
  case card.group of
    A -> "?"
    B -> "="

cardFrontTextA card =
  case card.id of
     1 -> "1×1"
     2 -> "2×2"
     3 -> "3×3"
     4 -> "4×4"
     5 -> "5×5"
     6 -> "6x6"
     7 -> "7x7"
     8 -> "8x8"
     _ -> "!!"

cardFrontTextB card =
  case card.id of
     1 -> "1"
     2 -> "4"
     3 -> "9"
     4 -> "16"
     5 -> "25"
     6 -> "36"
     7 -> "49"
     8 -> "56"
     _ -> "!!"

viewCardFront card =
   div [ class "card-front" ]
     (case card.group of
        A -> [text (cardFrontTextA card)]
        B -> [ div [] [text (cardFrontTextB card)]
             , div [ class "hint" ] [text (cardFrontTextA card)]
             ]
     )

viewCard : Card -> Html Msg
viewCard card =
    div [ classList [ ( "card", True ), ( "flipped", card.flipped ) ], onClick (Flip card) ]
          [ div [ class "card-back" ] [text (cardBackText card)]
          , viewCardFront card
          ]

view : Model -> Html Msg
view model =
    case model of
        Playing deck ->
            div [ id "container" ]
              (h1 [] [text "Memory Card Game (4x4) - Elm Starter Sample"]
               :: List.map viewCard deck
              )
