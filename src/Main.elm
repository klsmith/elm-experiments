module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Element exposing (Element, centerX, centerY, column, el, fill, layout, rgb, text)
import Element.Background as Background
import Element.Input as Input
import Html exposing (Html)



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type Page
    = ReversePage
    | ForwardPage


type alias Model =
    { page : Page
    , content : String
    }


init : Model
init =
    { page = ReversePage
    , content = ""
    }



-- UPDATE


type Msg
    = Change String
    | Navigate Page


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }

        Navigate newPage ->
            { model | page = newPage }



-- VIEW


white =
    rgb 1 1 1


view : Model -> Html Msg
view model =
    layout []
        (el
            [ Background.color white
            , Element.width fill
            , Element.height fill
            ]
            (el [ centerX, centerY ]
                (column []
                    [ Input.button []
                        { onPress = Just (getPageNavigation model)
                        , label = text (getPageTitle model ++ " : ")
                        }
                    , Input.text []
                        { onChange = Change
                        , text = model.content
                        , placeholder = Nothing
                        , label = Input.labelHidden (getPageTitle model)
                        }
                    , el [] (text (transformText model))
                    ]
                )
            )
        )


getPageNavigation : Model -> Msg
getPageNavigation model =
    case model.page of
        ReversePage ->
            Navigate ForwardPage

        ForwardPage ->
            Navigate ReversePage


getPageTitle : Model -> String
getPageTitle model =
    case model.page of
        ReversePage ->
            "Reverse"

        ForwardPage ->
            "Forward"


transformText : Model -> String
transformText model =
    case model.page of
        ReversePage ->
            String.reverse model.content

        ForwardPage ->
            model.content
