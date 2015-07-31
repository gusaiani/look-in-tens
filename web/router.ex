defmodule Dez.Router do
  use Dez.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dez do
    pipe_through :browser

    get "/", PageController, :index
    resources "/companies", CompanyController
  end
end
