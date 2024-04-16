module Main exposing (main)

import Board exposing (Board, Cell(..), Pos)
import Browser exposing (Document)
import Html exposing (div)
import Html.Attributes exposing (class)
import Turn exposing (Turn(..))


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { board : Board
    , turn : Turn
    , selected : Maybe Pos
    , showMove : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { board = Board.init
      , turn = Turn.init
      , selected = Nothing
      , showMove = True
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | OnSelect Pos


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnSelect pos ->
            case model.selected of
                Nothing ->
                    if Board.get pos model.board == Turn.toCell model.turn then
                        ( { model | selected = Just pos }, Cmd.none )

                    else
                        ( model, Cmd.none )

                Just selected ->
                    let
                        newBoard =
                            Board.move selected pos (Turn.toCell model.turn) model.board
                    in
                    case newBoard of
                        Just board ->
                            ( { model
                                | selected = Nothing
                                , board = board
                                , turn = Turn.toggle model.turn
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            if Board.get pos model.board == Turn.toCell model.turn then
                                ( { model | selected = Just pos }, Cmd.none )

                            else
                                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view m =
    let
        overlay =
            case Board.checkWin m.board of
                Just White ->
                    [ div [ class "overlay white" ] [] ]

                Just Black ->
                    [ div [ class "overlay black" ] [] ]

                _ ->
                    []
    in
    { title = "Ethiopian Dama"
    , body =
        [ Turn.view WhiteTurn m.turn
        , Board.view OnSelect m.selected m.board
        , Turn.view BlackTurn m.turn
        ]
            ++ overlay
    }
