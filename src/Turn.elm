module Turn exposing (Turn(..), init, toCell, toggle, view)

import Board exposing (Cell(..))
import Html exposing (Html, div)
import Html.Attributes exposing (class)


type Turn
    = BlackTurn
    | WhiteTurn


init : Turn
init =
    BlackTurn


toCell : Turn -> Cell
toCell turn =
    case turn of
        BlackTurn ->
            Black

        WhiteTurn ->
            White


toggle : Turn -> Turn
toggle turn =
    case turn of
        BlackTurn ->
            WhiteTurn

        WhiteTurn ->
            BlackTurn


view : Turn -> Turn -> Html msg
view expected turn =
    div
        [ class
            (if expected == turn then
                case turn of
                    WhiteTurn ->
                        "turn white"

                    BlackTurn ->
                        "turn black"

             else
                "turn"
            )
        ]
        []
