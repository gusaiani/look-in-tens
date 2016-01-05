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

  scope "/api", Dez do
    pipe_through :api

    resources "companies", CompanyController, only: [:show]
    get "companies/search/:query_str", CompanyController, :search
  end

  scope "/", Dez do
    pipe_through :browser

    get "/about", PageController, :about
    get "*path", PageController, :index
  end
end
