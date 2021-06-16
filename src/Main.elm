module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events
import Svg
import Svg.Attributes


increaseValue : Float -> Float -> Float
increaseValue currentValue currentStep =
    if (currentValue + currentStep) <= upperLimit then
        currentValue + currentStep

    else
        currentValue


decreaseValue : Float -> Float -> Float
decreaseValue currentValue currentStep =
    if (currentValue - currentStep) >= lowerLimit then
        currentValue - currentStep

    else
        currentValue


calcAngle : Float -> Float
calcAngle value =
    -- interpolacion lineal 0->30º 20->330º
    30 + (((330 - 30) / 20) * value)


checkLowerLimit : Float -> Bool
checkLowerLimit value =
    if value <= lowerLimit then
        True

    else
        False


checkUpperLimit : Float -> Bool
checkUpperLimit value =
    if value >= upperLimit then
        True

    else
        False


checkStep : Float -> Float -> Bool
checkStep step currentStep =
    if step == currentStep then
        True

    else
        False



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }



-- MODEL


initialAngle =
    30


initialValue =
    0


lowerLimit =
    0


upperLimit =
    20


initialStep =
    1


type alias Model =
    { value : Float
    , step : Float
    , dialAngle : Float
    , decreaseDisabled : Bool
    , increaseDisabled : Bool
    }


initialModel : Model
initialModel =
    { value = initialValue
    , step = initialStep
    , dialAngle = initialAngle
    , decreaseDisabled = checkLowerLimit initialValue
    , increaseDisabled = checkUpperLimit initialValue
    }



-- UPDATE


type Msg
    = Increase
    | Decrease
    | SetStep Float
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { value = increaseValue model.value model.step
            , step = model.step
            , dialAngle = calcAngle model.value
            , decreaseDisabled = checkLowerLimit model.value
            , increaseDisabled = checkUpperLimit model.value
            }

        Decrease ->
            { value = decreaseValue model.value model.step
            , step = model.step
            , dialAngle = calcAngle model.value
            , decreaseDisabled = checkLowerLimit model.value
            , increaseDisabled = checkUpperLimit model.value
            }

        SetStep newStep ->
            { value = model.value
            , step = newStep
            , dialAngle = model.dialAngle
            , decreaseDisabled = model.decreaseDisabled
            , increaseDisabled = model.increaseDisabled
            }

        Reset ->
            { value = initialValue
            , step = initialStep
            , dialAngle = initialAngle
            , decreaseDisabled = checkLowerLimit initialValue
            , increaseDisabled = checkUpperLimit initialValue
            }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "flex flex-col justify-center items-center p-20 space-y-4" ]
        [ div
            [ class "flex justify-center" ]
            [ viewDial (calcAngle model.value) ]
        , div
            -- white box
            [ class "flex flex-col max-w-xs px-4 py-10 bg-white shadow-lg sm:rounded-2xl sm:p-5" ]
            [ div
                -- value box
                [ class "flex justify-center items-center sm:p-1" ]
                [ div
                    [ class "px-2" ]
                    [ text "Value" ]
                , Html.button
                    [ class "px-3 py-1 rounded-l-lg bg-gray-200 hover:bg-gray-400 focus:outline-none transition-colors duration-150 disabled:opacity-50 font-medium"
                    , Html.Events.onClick Decrease
                    , Html.Attributes.disabled model.decreaseDisabled
                    , Html.Attributes.classList [ ( "cursor-not-allowed", model.decreaseDisabled ) ]
                    ]
                    --[ text "-" ]
                    [ Svg.svg
                        [ Svg.Attributes.width "24"
                        , Svg.Attributes.height "24"
                        , Svg.Attributes.fill "#666"
                        ]
                        [ Svg.path
                            [ Svg.Attributes.d "M7 11v2h10v-2H7zm5-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"
                            , Svg.Attributes.stroke "#666"
                            ]
                            []
                        ]
                    ]
                , div
                    [ class "text-center font-black px-2 py-1 w-14 bg-gray-50 border-solid border-1 border-r-0 border-l-0 border-gray-400 select-none" ]
                    [ text <| String.fromFloat model.value ]
                , Html.button
                    [ class "px-3 py-1 rounded-r-lg bg-gray-200 hover:bg-gray-400 focus:outline-none transition-colors duration-150 disabled:opacity-50 font-medium"
                    , Html.Events.onClick Increase
                    , Html.Attributes.disabled model.increaseDisabled
                    , Html.Attributes.classList [ ( "cursor-not-allowed", model.increaseDisabled ) ]
                    ]
                    --[ text "+" ]
                    [ Svg.svg
                        [ Svg.Attributes.width "24"
                        , Svg.Attributes.height "24"
                        , Svg.Attributes.fill "#666"
                        ]
                        [ Svg.path
                            [ Svg.Attributes.d "M13 7h-2v4H7v2h4v4h2v-4h4v-2h-4V7zm-1-5C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"
                            , Svg.Attributes.stroke "#666"
                            ]
                            []
                        ]
                    ]
                ]
            , div
                -- step buttons
                [ class "flex justify-center items-center sm:p-1 mb-5" ]
                [ div
                    [ class "px-2" ]
                    [ text "Step" ]
                , Html.button
                    [ class "px-3 py-1 rounded-l-lg bg-gray-200 hover:bg-gray-400 transition-colors duration-150 focus:outline-none font-medium"
                    , Html.Events.onClick (SetStep 1)
                    , Html.Attributes.classList [ ( "bg-gray-400", checkStep 1 model.step ) ]
                    ]
                    [ text "1" ]
                , Html.button
                    [ class "px-3 py-1 bg-gray-200 hover:bg-gray-400 transition-colors duration-150 focus:outline-none font-medium"
                    , Html.Events.onClick (SetStep 0.5)
                    , Html.Attributes.classList [ ( "bg-gray-400", checkStep 0.5 model.step ) ]
                    ]
                    [ text "½" ]
                , Html.button
                    [ class "px-3 py-1 rounded-r-lg bg-gray-200 hover:bg-gray-400 transition-colors duration-150 focus:outline-none font-medium"
                    , Html.Events.onClick (SetStep 0.25)
                    , Html.Attributes.classList [ ( "bg-gray-400", checkStep 0.25 model.step ) ]
                    ]
                    [ text "¼" ]
                ]
            , div
                -- reset button
                [ class "flex justify-center items-center sm:p-1" ]
                [ Html.button
                    [ class "px-4 py-1 rounded bg-gray-200 hover:bg-red-500 hover:text-white transition-colors duration-500 focus:outline-none font-medium"
                    , Html.Events.onClick Reset
                    ]
                    [ text "RESET" ]
                ]
            ]
        ]


viewDial : Float -> Html msg
viewDial angle =
    div
        []
        [ Svg.svg
            [ Svg.Attributes.width "153"
            , Svg.Attributes.height "181"
            , Svg.Attributes.fill "none"
            ]
            [ -- Lines indicating max & min
              Svg.path
                [ Svg.Attributes.d "M43.933 48.19l-10-17.32M106.933 48.69l10-17.32"
                , Svg.Attributes.stroke "#000"
                ]
                []

            -- Dial
            , Svg.g
                -- Dial circle
                [ Svg.Attributes.transform <| "rotate(" ++ String.fromFloat angle ++ " 75 103)" ]
                [ Svg.circle
                    [ Svg.Attributes.cx "75"
                    , Svg.Attributes.cy "103"
                    , Svg.Attributes.r "75"
                    , Svg.Attributes.fill "#9C9C9C"
                    ]
                    []
                , Svg.path
                    -- Dial arrow
                    [ Svg.Attributes.d "M75 31.922L88.235 55.45h-26.47L75 31.921z"
                    , Svg.Attributes.fill "#FF0000"
                    ]
                    []
                ]

            -- Text
            , Svg.path
                [ Svg.Attributes.d "M110.936 28v-6.24h1.308v1.032h.06c.064-.16.14-.312.228-.456.096-.144.208-.268.336-.372.136-.112.292-.196.468-.252.184-.064.396-.096.636-.096.424 0 .8.104 1.128.312.328.208.568.528.72.96h.036c.112-.352.328-.652.648-.9s.732-.372 1.236-.372c.624 0 1.108.212 1.452.636.344.416.516 1.012.516 1.788V28H118.4v-3.804c0-.48-.092-.84-.276-1.08-.184-.248-.476-.372-.876-.372-.168 0-.328.024-.48.072-.152.04-.288.104-.408.192-.112.088-.204.2-.276.336a.985.985 0 00-.108.468V28h-1.308v-3.804c0-.968-.38-1.452-1.14-1.452-.16 0-.32.024-.48.072-.152.04-.288.104-.408.192a.977.977 0 00-.288.336.985.985 0 00-.108.468V28h-1.308zm11.242-7.356c-.272 0-.472-.064-.6-.192a.69.69 0 01-.18-.492v-.204c0-.2.06-.364.18-.492.128-.128.328-.192.6-.192.272 0 .468.064.588.192a.69.69 0 01.18.492v.204c0 .2-.06.364-.18.492s-.316.192-.588.192zm-.66 1.116h1.308V28h-1.308v-6.24zm3.176 6.24v-6.24h1.308v1.032h.06a2.08 2.08 0 01.612-.84c.28-.224.66-.336 1.14-.336.64 0 1.136.212 1.488.636.36.416.54 1.012.54 1.788V28h-1.308v-3.792c0-.976-.392-1.464-1.176-1.464-.168 0-.336.024-.504.072a1.32 1.32 0 00-.432.192c-.128.088-.232.2-.312.336a1.012 1.012 0 00-.108.48V28h-1.308zM21.936 28v-6.24h1.308v1.032h.06c.064-.16.14-.312.228-.456.096-.144.208-.268.336-.372.136-.112.292-.196.468-.252.184-.064.396-.096.636-.096.424 0 .8.104 1.128.312.328.208.568.528.72.96h.036c.112-.352.328-.652.648-.9s.732-.372 1.236-.372c.624 0 1.108.212 1.452.636.344.416.516 1.012.516 1.788V28H29.4v-3.804c0-.48-.092-.84-.276-1.08-.184-.248-.476-.372-.876-.372-.168 0-.328.024-.48.072-.152.04-.288.104-.408.192-.112.088-.204.2-.276.336a.985.985 0 00-.108.468V28h-1.308v-3.804c0-.968-.38-1.452-1.14-1.452-.16 0-.32.024-.48.072-.152.04-.288.104-.408.192a.977.977 0 00-.288.336.985.985 0 00-.108.468V28h-1.308zm15.154 0c-.344 0-.608-.096-.792-.288a1.344 1.344 0 01-.336-.756h-.06c-.12.392-.34.688-.66.888-.32.2-.708.3-1.164.3-.648 0-1.148-.168-1.5-.504-.344-.336-.516-.788-.516-1.356 0-.624.224-1.092.672-1.404.456-.312 1.12-.468 1.992-.468h1.128v-.528c0-.384-.104-.68-.312-.888-.208-.208-.532-.312-.972-.312-.368 0-.668.08-.9.24-.232.16-.428.364-.588.612l-.78-.708c.208-.352.5-.64.876-.864.376-.232.868-.348 1.476-.348.808 0 1.428.188 1.86.564.432.376.648.916.648 1.62v3.132h.66V28h-.732zm-2.64-.852c.408 0 .744-.088 1.008-.264.264-.184.396-.428.396-.732v-.9H34.75c-.904 0-1.356.28-1.356.84v.216c0 .28.092.492.276.636.192.136.452.204.78.204zm3.958.852l2.196-3.156-2.136-3.084h1.512l1.404 2.172h.036l1.44-2.172h1.392l-2.136 3.072L44.288 28h-1.512l-1.44-2.268H41.3L39.8 28h-1.392z"
                , Svg.Attributes.fill "#FF0000"
                ]
                []
            ]
        ]
