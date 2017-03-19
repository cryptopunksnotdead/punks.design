module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random


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

type Group
    = A
    | B

type alias Deck =
    List Card


type Model
    = Playing Deck
    | Guessing Deck Card
    | MatchCard Deck Card Card
    | GameOver Deck


type Msg
    = NoOp
    | Reset
    | Shuffle (List Int)
    | Flip Card



-- MODEL

createDeck : Deck
createDeck = [
     (Card 1 A False),
     (Card 2 A False),
     (Card 3 A False),
     (Card 4 A False),
     (Card 5 A False),
     (Card 6 A False),
     (Card 7 A False),
     (Card 8 A False),
     (Card 1 B False),
     (Card 2 B False),
     (Card 3 B False),
     (Card 4 B False),
     (Card 5 B False),
     (Card 6 B False),
     (Card 7 B False),
     (Card 8 B False)
   ]

createModel : ( Model, Cmd Msg )
createModel =
    let
        deck =
            createDeck

        model =
            Playing deck

        cmd =
            randomList Shuffle (List.length deck)
    in
        ( model, cmd )


-- UPDATE


randomList : (List Int -> Msg) -> Int -> Cmd Msg
randomList msg len =
    Random.int 0 100
        |> Random.list len
        |> Random.generate msg


shuffleDeck : Deck -> List comparable -> Deck
shuffleDeck deck xs =
    List.map2 (,) deck xs
        |> List.sortBy Tuple.second
        |> List.unzip
        |> Tuple.first


flip : Bool -> Card -> Card -> Card
flip isFlipped a b =
    if (a.id == b.id) && (a.group == b.group) then
        { b | flipped = isFlipped }
    else
        b


checkIfCorrect : Card -> Model -> ( Model, Cmd Msg )
checkIfCorrect card model =
    case model of
        Playing deck ->
            let
                newDeck =
                    List.map (flip True card) deck
            in
                Guessing newDeck card ! []

        Guessing deck guess ->
            let
                newDeck =
                    List.map (flip True card) deck

                {-
                   when all cards are flipped, the game is over
                -}
                isOver =
                    List.all .flipped newDeck

                newModel =
                    if isOver then
                        GameOver newDeck
                    else
                        MatchCard newDeck guess card
            in
                newModel ! []

        MatchCard deck guess1 guess2 ->
            if guess1.id == guess2.id then
                {-
                   user has guessed correctly!
                   keep both cards flipped and then run update
                   again to flip the new card that has been just clicked
                -}
                update (Flip card) (Playing deck)
            else
                -- flip the two cards face down because they don't match
                let
                    flipGuess =
                        flip False guess1 >> flip False guess2

                    newDeck =
                        List.map flipGuess deck
                in
                    Playing newDeck ! []

        GameOver deck ->
            GameOver deck ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Shuffle xs ->
            let
                newDeck =
                    shuffleDeck createDeck xs   -- todo/check: why create new deck??
            in
                Playing newDeck ! []

        Reset ->
            createModel

        Flip card ->
            if card.flipped then
                -- if a user clicks on an image that's flipped already
                -- then don't do anything
                model ! []
            else
                checkIfCorrect card model



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




viewPlayAgainOverlay : Html Msg
viewPlayAgainOverlay =
    div [ id "congrats" ]    -- fix: use id congrats ??
        [ p [] [ text "Congrats! You win!" ]
        , text "Do you want to "
        , span [ onClick Reset ] [ text "play again?" ]
        ]



viewGameOver : Deck -> Html Msg
viewGameOver deck =
    div [] [ viewGame deck, viewPlayAgainOverlay ]


viewGame : Deck -> Html Msg
viewGame deck =
    div [ id "container" ]
        (h1 [] [text "Memory Card Game (4x4) - Elm Starter Sample"]
        :: List.map viewCard deck
        )



view : Model -> Html Msg
view model =
    case model of
        Playing deck       -> viewGame deck
        Guessing deck _    -> viewGame deck
        MatchCard deck _ _ -> viewGame deck
        GameOver deck      -> viewGameOver deck
