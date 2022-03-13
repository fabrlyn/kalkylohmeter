module Input exposing (Model, Msg, update, updateValue, view)

import Css exposing (alignItems, backgroundColor, border, borderRadius, boxShadow, center, color, cursor, default, displayFlex, flex, flexEnd, focus, fontFamilies, fontSize, height, hex, inset, justifyContent, letterSpacing, marginLeft, marginRight, maxWidth, none, outline, paddingLeft, paddingRight, pct, pointer, px, rgba, right, textAlign, width)
import Html.Styled exposing (Html, div, input, text)
import Html.Styled.Attributes exposing (css, readonly, value)
import Html.Styled.Events exposing (onInput)
import Shared exposing (Unit(..))
import String exposing (fromFloat)


fontColor : Css.Color
fontColor =
    hex "#497486"


background : Css.Color
background =
    hex "#B0DDE4"


unitToString : Unit -> String
unitToString unit =
    case unit of
        Volts ->
            "V"

        Ohm ->
            "Ω"

        Amps ->
            "A"


type alias Model =
    { value : Float
    , innerValue : String
    , unit : Unit
    , readOnly : Bool
    }


type Msg
    = OnInputChange String


updateValue : Float -> Model -> Model
updateValue value model =
    { model | value = value, innerValue = String.fromFloat value }


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInputChange s ->
            case String.toFloat s of
                Just f ->
                    { model | value = f, innerValue = s }

                _ ->
                    { model | innerValue = s }


unitText : Unit -> Html Msg
unitText unit =
    let
        marginPx =
            10
    in
    div
        [ css
            [ marginLeft (px marginPx)
            , fontSize (px 55)
            , cursor default
            , width (px 55)
            ]
        ]
        [ text (unitToString unit) ]


valueText : Model -> Html Msg
valueText model =
    input
        [ css
            [ border (px 0)
            , backgroundColor background
            , color fontColor
            , fontSize (px 55)
            , textAlign right
            , fontFamilies [ "ZCOOL QingKe HuangYou" ]
            , letterSpacing (pct 2)
            , maxWidth (px 320)
            , cursor default
            , focus [ outline none ]
            ]
        , value model.innerValue
        , readonly model.readOnly
        , onInput OnInputChange
        ]
        []


view : Model -> Html Msg
view model =
    div
        [ css
            [ displayFlex
            , borderRadius (px 10)
            , backgroundColor background
            , justifyContent flexEnd
            , alignItems center
            , width (px 400)
            , height (px 90)
            , Css.boxShadow6 inset (px 2) (px 2) (px 3) (px 1) (rgba 0 0 0 0.25)
            ]
        ]
        [ valueText model
        , unitText model.unit
        ]
