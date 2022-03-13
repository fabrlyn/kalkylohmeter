port module Main exposing (..)

import Browser
import Browser.Navigation exposing (Key)
import Css exposing (alignItems, backgroundColor, center, color, displayFlex, fontFamilies, fontSize, height, hex, justifyContent, letterSpacing, margin, marginTop, pct, px)
import Css.Global exposing (body, global, html)
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Input
import Shared exposing (Unit(..))
import String exposing (fromFloat)
import Url
import Wheel


port wasmLoaded : (Bool -> msg) -> Sub msg


port calculateVolts : { amps : Float, ohm : Float } -> Cmd msg


port calculatedVolts : (Float -> msg) -> Sub msg


port calculateAmps : { volts : Float, ohm : Float } -> Cmd msg


port calculatedAmps : (Float -> msg) -> Sub msg


port calculateOhm : { volts : Float, amps : Float } -> Cmd msg


port calculatedOhm : (Float -> msg) -> Sub msg


wheelStripeColor : Css.Color
wheelStripeColor =
    hex "#F6F6F6"


wheelColor : Css.Color
wheelColor =
    hex "#406368"


fontColor : Css.Color
fontColor =
    hex "#497486"


type alias Flags =
    ()


type alias Model =
    { wasmLoaded : Bool
    , wheelModel : Wheel.Model
    , voltsInput : Input.Model
    , ampsInput : Input.Model
    , ohmInput : Input.Model
    }


type Msg
    = WasmLoaded Bool
    | WheelMsg Wheel.Msg
    | VoltsInputMsg Input.Msg
    | AmpsInputMsg Input.Msg
    | OhmInputMsg Input.Msg
    | CalculateVolts { amps : Float, ohm : Float }
    | CalculateOhm { amps : Float, volts : Float }
    | CalculateAmps { volts : Float, ohm : Float }
    | Calculated Float
    | CalculatedOhm Float
    | CalculatedAmps Float
    | NoOp


init : Flags -> Url.Url -> Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { wasmLoaded = False
      , wheelModel = Wheel.initModel
      , voltsInput =
            { value = 0.0
            , unit = Volts
            , innerValue = fromFloat 0.0
            , readOnly = False
            }
      , ampsInput =
            { value = 0.0
            , unit = Amps
            , innerValue = fromFloat 0.0
            , readOnly = False
            }
      , ohmInput =
            { value = 0.0
            , unit = Ohm
            , innerValue = fromFloat 0.0
            , readOnly = False
            }
      }
    , Cmd.none
    )


styledView : Model -> Html.Styled.Html Msg
styledView model =
    let
        voltsInput =
            model.voltsInput

        ampsInput =
            model.ampsInput

        ohmInput =
            model.ohmInput

        voltsView =
            Html.Styled.map VoltsInputMsg (Input.view { voltsInput | readOnly = model.wheelModel.unit == Volts })

        ampsView =
            Html.Styled.map AmpsInputMsg (Input.view { ampsInput | readOnly = model.wheelModel.unit == Amps })

        ohmView =
            Html.Styled.map OhmInputMsg (Input.view { ohmInput | readOnly = model.wheelModel.unit == Ohm })

        ( first, second, third ) =
            case model.wheelModel.unit of
                Volts ->
                    ( voltsView, ampsView, ohmView )

                Amps ->
                    ( ampsView, voltsView, ohmView )

                Ohm ->
                    ( ohmView, voltsView, ampsView )
    in
    div
        [ css
            [ fontFamilies [ "ZCOOL QingKe HuangYou" ]
            , color fontColor
            , letterSpacing (pct 2)
            , fontSize (px 64)
            ]
        ]
        [ global
            [ html
                [ height (pct 100)
                , margin (px 0)
                ]
            , body
                [ backgroundColor (hex "#96BBC1")
                , margin (px 0)
                ]
            ]
        , div
            [ css
                [ displayFlex
                , justifyContent center
                , alignItems center
                , marginTop (px 50)
                ]
            ]
            [ first ]
        , div
            [ css
                [ displayFlex
                , justifyContent center
                , alignItems center
                , marginTop (px 50)
                ]
            ]
            [ Html.Styled.map WheelMsg (Wheel.view model.wheelModel) ]
        , div
            [ css
                [ displayFlex
                , justifyContent center
                , alignItems center
                , marginTop (px 90)
                ]
            ]
            [ second ]
        , div
            [ css
                [ displayFlex
                , justifyContent center
                , alignItems center
                , marginTop (px 30)
                ]
            ]
            [ third ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "ohms law"
    , body = [ Html.Styled.toUnstyled (styledView model) ]
    }



--calculate : Model -> Float -> Cmd Msg


calculate unit volts amps ohm =
    case unit of
        Volts ->
            calculateVolts { amps = amps, ohm = ohm }

        Amps ->
            calculateAmps { volts = volts, ohm = ohm }

        Ohm ->
            calculateOhm { volts = volts, amps = amps }


calculated : Model -> Float -> Model
calculated model value =
    case model.wheelModel.unit of
        Volts ->
            { model | voltsInput = Input.updateValue value model.voltsInput }

        Amps ->
            { model | ampsInput = Input.updateValue value model.ampsInput }

        Ohm ->
            { model | ohmInput = Input.updateValue value model.ohmInput }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WasmLoaded loaded ->
            ( { model | wasmLoaded = loaded }, Cmd.none )

        WheelMsg wheelMsg ->
            ( { model
                | wheelModel = Wheel.update wheelMsg model.wheelModel
              }
            , Cmd.none
            )

        VoltsInputMsg voltsInputMsg ->
            let
                newVoltsInput =
                    Input.update voltsInputMsg model.voltsInput
            in
            ( { model | voltsInput = newVoltsInput }
            , calculate model.wheelModel.unit newVoltsInput.value model.ampsInput.value model.ohmInput.value
            )

        AmpsInputMsg ampsInputMsg ->
            let
                newAmpsInput =
                    Input.update ampsInputMsg model.ampsInput
            in
            ( { model | ampsInput = newAmpsInput }
            , calculate model.wheelModel.unit model.voltsInput.value newAmpsInput.value model.ohmInput.value
            )

        OhmInputMsg ohmInputMsg ->
            let
                newOhmInput =
                    Input.update ohmInputMsg model.ohmInput
            in
            ( { model | ohmInput = newOhmInput }
            , calculate model.wheelModel.unit model.voltsInput.value model.ampsInput.value newOhmInput.value
            )

        Calculated value ->
            ( calculated model value, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ wasmLoaded WasmLoaded
        , calculatedVolts Calculated
        , calculatedAmps Calculated
        , calculatedOhm Calculated
        ]


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    NoOp


onUrlChange : Url.Url -> Msg
onUrlChange _ =
    NoOp


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }
