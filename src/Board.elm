module Board exposing (Board, Cell(..), Pos(..), checkWin, get, init, move, view)

import Html exposing (Html, button, div, section)
import Html.Attributes exposing (class, selected)
import Html.Events exposing (onClick)


type alias Board =
    { topLeft : Cell
    , topMiddle : Cell
    , topRight : Cell
    , middleLeft : Cell
    , middleMiddle : Cell
    , middleRight : Cell
    , bottomLeft : Cell
    , bottomMiddle : Cell
    , bottomRight : Cell
    }


type Cell
    = Empty
    | Black
    | White


type Pos
    = TopLeft
    | TopMiddle
    | TopRight
    | MiddleLeft
    | MiddleMiddle
    | MiddleRight
    | BottomLeft
    | BottomMiddle
    | BottomRight


init : Board
init =
    Board White White White Empty Empty Empty Black Black Black


get : Pos -> Board -> Cell
get pos board =
    case pos of
        TopLeft ->
            board.topLeft

        TopMiddle ->
            board.topMiddle

        TopRight ->
            board.topRight

        MiddleLeft ->
            board.middleLeft

        MiddleMiddle ->
            board.middleMiddle

        MiddleRight ->
            board.middleRight

        BottomLeft ->
            board.bottomLeft

        BottomMiddle ->
            board.bottomMiddle

        BottomRight ->
            board.bottomRight


set : Pos -> Cell -> Board -> Board
set pos cell board =
    case pos of
        TopLeft ->
            { board | topLeft = cell }

        TopMiddle ->
            { board | topMiddle = cell }

        TopRight ->
            { board | topRight = cell }

        MiddleLeft ->
            { board | middleLeft = cell }

        MiddleMiddle ->
            { board | middleMiddle = cell }

        MiddleRight ->
            { board | middleRight = cell }

        BottomLeft ->
            { board | bottomLeft = cell }

        BottomMiddle ->
            { board | bottomMiddle = cell }

        BottomRight ->
            { board | bottomRight = cell }


move : Pos -> Pos -> Cell -> Board -> Maybe Board
move from to cell board =
    if List.member to (availableMoves from board) then
        Just (board |> set from Empty |> set to cell)

    else
        Nothing


possibleMoves : Pos -> List Pos
possibleMoves pos =
    case pos of
        TopLeft ->
            [ MiddleLeft, MiddleMiddle, TopMiddle ]

        TopMiddle ->
            [ TopLeft, MiddleMiddle, TopRight ]

        TopRight ->
            [ TopMiddle, MiddleMiddle, MiddleRight ]

        MiddleLeft ->
            [ TopLeft, MiddleMiddle, BottomLeft ]

        MiddleMiddle ->
            [ TopLeft, TopMiddle, TopRight, MiddleLeft, MiddleRight, BottomLeft, BottomMiddle, BottomRight ]

        MiddleRight ->
            [ TopRight, MiddleMiddle, BottomRight ]

        BottomLeft ->
            [ MiddleLeft, MiddleMiddle, BottomMiddle ]

        BottomMiddle ->
            [ BottomLeft, MiddleMiddle, BottomRight ]

        BottomRight ->
            [ BottomMiddle, MiddleMiddle, MiddleRight ]


availableMoves : Pos -> Board -> List Pos
availableMoves pos board =
    possibleMoves pos |> List.filter (\p -> get p board == Empty)


viewCell : Cell -> Bool -> msg -> Html msg
viewCell cell selected click =
    let
        selectedClass =
            if selected then
                " selected"

            else
                ""

        turnClass =
            case cell of
                Empty ->
                    ""

                Black ->
                    " black"

                White ->
                    " white"
    in
    button [ class ("cell" ++ turnClass ++ selectedClass), onClick click ] []


viewSeprator : String -> Html msg
viewSeprator dir =
    div [ class ("sep " ++ dir) ] []


isSelected : Pos -> Maybe Pos -> Bool
isSelected pos maybe =
    maybe |> Maybe.map (\p -> p == pos) |> Maybe.withDefault False


view : (Pos -> msg) -> Maybe Pos -> Board -> Html msg
view onSelect selected board =
    section [ class "board" ]
        [ viewCell board.topLeft (isSelected TopLeft selected) (onSelect TopLeft)
        , viewSeprator "horizontal"
        , viewCell board.topMiddle (isSelected TopMiddle selected) (onSelect TopMiddle)
        , viewSeprator "horizontal"
        , viewCell board.topRight (isSelected TopRight selected) (onSelect TopRight)
        , viewSeprator "vertical"
        , viewSeprator "rtl"
        , viewSeprator "vertical"
        , viewSeprator "ltr"
        , viewSeprator "vertical"
        , viewCell board.middleLeft (isSelected MiddleLeft selected) (onSelect MiddleLeft)
        , viewSeprator "horizontal"
        , viewCell board.middleMiddle (isSelected MiddleMiddle selected) (onSelect MiddleMiddle)
        , viewSeprator "horizontal"
        , viewCell board.middleRight (isSelected MiddleRight selected) (onSelect MiddleRight)
        , viewSeprator "vertical"
        , viewSeprator "ltr"
        , viewSeprator "vertical"
        , viewSeprator "rtl"
        , viewSeprator "vertical"
        , viewCell board.bottomLeft (isSelected BottomLeft selected) (onSelect BottomLeft)
        , viewSeprator "horizontal"
        , viewCell board.bottomMiddle (isSelected BottomMiddle selected) (onSelect BottomMiddle)
        , viewSeprator "horizontal"
        , viewCell board.bottomRight (isSelected BottomRight selected) (onSelect BottomRight)
        ]


checkWin : Board -> Maybe Cell
checkWin b =
    (checkTriple b.topLeft b.topMiddle b.topRight |> isNot White)
        |> or (checkTriple b.bottomLeft b.bottomMiddle b.bottomRight |> isNot Black)
        |> or (checkTriple b.middleLeft b.middleMiddle b.middleRight)
        |> or (checkTriple b.topLeft b.middleLeft b.bottomLeft)
        |> or (checkTriple b.topMiddle b.middleMiddle b.bottomMiddle)
        |> or (checkTriple b.topRight b.middleRight b.bottomRight)
        |> or (checkTriple b.topLeft b.middleMiddle b.bottomRight)
        |> or (checkTriple b.topRight b.middleMiddle b.bottomLeft)


checkTriple : Cell -> Cell -> Cell -> Maybe Cell
checkTriple x y z =
    if x == y && y == z then
        Just x

    else
        Nothing


isNot : Cell -> Maybe Cell -> Maybe Cell
isNot cell =
    Maybe.andThen
        (\x ->
            if x == cell then
                Nothing

            else
                Just x
        )


or : Maybe a -> Maybe a -> Maybe a
or x y =
    case ( x, y ) of
        ( Just a, Nothing ) ->
            Just a

        ( Nothing, Just b ) ->
            Just b

        ( Just a, Just _ ) ->
            Just a

        ( Nothing, Nothing ) ->
            Nothing
