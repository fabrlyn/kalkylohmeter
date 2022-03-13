module Wheel exposing (Model, Msg, initModel, update, view)

import Css exposing (absolute, alignItems, backgroundColor, borderRadius, boxShadow5, boxShadow6, center, cursor, default, deg, displayFlex, height, hex, inset, justifyContent, left, pct, position, px, relative, rgba, rotate, textAlign, transform, width)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css, style)
import Html.Styled.Events exposing (onClick)
import Shared exposing (Unit(..))


wheelColor : Css.Color
wheelColor =
    hex "#406368"


arrowColor : Css.Color
arrowColor =
    hex "#F6F6F6"


unitToDegree : Unit -> Float
unitToDegree unit =
    case unit of
        Volts ->
            0

        Ohm ->
            90

        Amps ->
            -90


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnUnitChange unit ->
            { model | unit = unit }


type alias Model =
    { unit : Unit
    }


type Msg
    = OnUnitChange Unit


initModel : Model
initModel =
    { unit = Volts }


wheelView : { a | unit : Unit } -> Html.Styled.Html msg
wheelView model =
    let
        wheelDegree =
            unitToDegree model.unit

        _ =
            Debug.log "wheel degree" wheelDegree
    in
    div
        [ css
            [ height (px 300)
            , width (px 300)
            , backgroundColor wheelColor
            , borderRadius (pct 50)
            , boxShadow6 inset (px 4) (px 4) (px 25) (px 26) (rgba 0 0 0 0.25)
            , position relative
            ]
        ]
        [ div
            [ css
                [ height (px 150)
                , width (px 20)
                , backgroundColor arrowColor
                , borderRadius (px 20)
                , left (px 140)
                , position absolute
                , transform (rotate (deg wheelDegree))
                , boxShadow5 inset (px 5) (px 2) (px 4) (rgba 0 0 0 0.2)
                ]
            , style "transform-origin" "50% 100%"
            ]
            []
        ]


voltsView : Html.Styled.Html Msg
voltsView =
    div
        [ css
            [ width (px 70)
            , displayFlex
            , justifyContent center
            , alignItems center
            , textAlign center
            , cursor default
            ]
        , style "text-shadow" "1px 4px 6px #96BBC1, 0 0 0 #000, 1px 4px 6px #96BBC1"
        , style "color" "rgba(64, 99, 104, 0.7)"
        , onClick (OnUnitChange Volts)
        ]
        [ text "V" ]


ampView : Html.Styled.Html Msg
ampView =
    div
        [ css
            [ width (px 70)
            , displayFlex
            , justifyContent center
            , alignItems center
            , textAlign center
            , cursor default
            ]
        , style "text-shadow" "1px 4px 6px #96BBC1, 0 0 0 #000, 1px 4px 6px #96BBC1"
        , style "color" "rgba(64, 99, 104, 0.7)"
        , onClick (OnUnitChange Amps)
        ]
        [ text "A" ]


ohmView : Html.Styled.Html Msg
ohmView =
    div
        [ css
            [ width (px 70)
            , displayFlex
            , justifyContent center
            , alignItems center
            , textAlign center
            , cursor default
            ]
        , style "text-shadow" "1px 4px 6px #96BBC1, 0 0 0 #000, 1px 4px 6px #96BBC1"
        , style "color" "rgba(64, 99, 104, 0.7)"
        , onClick (OnUnitChange Ohm)
        ]
        [ text "Ω" ]


topRowView : Model -> Html.Styled.Html Msg
topRowView _ =
    div
        [ css
            [ displayFlex
            , justifyContent center
            , alignItems center
            ]
        ]
        [ voltsView ]


centerRowView : { a | unit : Unit } -> Html.Styled.Html Msg
centerRowView model =
    div
        [ css
            [ displayFlex
            , alignItems center
            , justifyContent center
            ]
        ]
        [ ampView, wheelView model, ohmView ]


view : Model -> Html.Styled.Html Msg
view model =
    div
        [ css
            []
        ]
        [ topRowView model
        , centerRowView model
        ]
