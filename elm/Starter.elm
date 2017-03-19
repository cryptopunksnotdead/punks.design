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
    { id : String
    , group : Group
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

createDeck : List Card
createDeck = [
     (Card "dinosaur" A False),
     (Card "8-ball" A True),
     (Card "baked-potato" A False),
     (Card "kronos" A False),
     (Card "rocket" A False),
     (Card "skinny-unicorn" A False),
     (Card "baked-potato" B False),
     (Card "that-guy" A True),
     (Card "rocket" B False),
     (Card "zeppelin" A False),
     (Card "kronos" B True),
     (Card "dinosaur" B False),
     (Card "that-guy" B False),
     (Card "zeppelin" B False),
     (Card "8-ball" B True),
     (Card "skinny-unicorn" B False)
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

viewCard : Card -> Html Msg
viewCard card =
    div [ classList [ ( "card", True ), ( "flipped", card.flipped ) ], onClick (Flip card) ]
          [ div [ class "card-back" ] []
          , div [ class ("card-front " ++ "card-" ++ card.id) ] []
          ]


---------------
-- todo: add h1 [] [text "Memory"] to div container

view : Model -> Html Msg
view model =
    case model of
        Playing deck ->
            div [ id "container" ]
              (h1 [][text "Memory Card Game (4x4) - Elm Starter Sample"]
               :: List.map viewCard deck
              )
