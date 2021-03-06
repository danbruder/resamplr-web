module Page.Products exposing (Model, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Data.Product exposing (Product)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.Product
import Task exposing (Task)
import Util exposing ((=>), onClickStopPropagation)
import Views.Page as Page


-- MODEL --


type alias Model =
    { products : List Product
    }


init : Task PageLoadError Model
init =
    let
        loadProducts =
            Request.Product.index
                |> Http.toTask

        handleLoadError _ =
            "Profile is currently unavailable."
                |> pageLoadError Page.Other
    in
    Task.map Model loadProducts
        |> Task.mapError handleLoadError



-- VIEW --


view : Model -> Html msg
view model =
    div [ class "products-page" ]
        [ viewProducts model ]


viewProducts : Model -> Html msg
viewProducts model =
    div [ class "row" ]
        (List.map viewTile model.products)


viewTile : Product -> Html msg
viewTile product =
    div [ class "product-tile-container col-sm-4 col-xs-12" ]
        [ div [ class "product-tile" ]
            [ h3 [] [ text product.name ]
            ]
        ]



-- UPDATE --


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
