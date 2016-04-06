require 'test_helper'

class DepositsControllerTest < ActionController::TestCase
  setup do
    @deposit = deposits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deposits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deposit" do
    assert_difference('Deposit.count') do
      post :create, deposit: { author: @deposit.author, creation_date: @deposit.creation_date, email: @deposit.email, project_url: @deposit.project_url, state: @deposit.state, status: @deposit.status, title: @deposit.title }
    end

    assert_redirected_to deposit_path(assigns(:deposit))
  end

  test "should show deposit" do
    get :show, id: @deposit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deposit
    assert_response :success
  end

  test "should update deposit" do
    patch :update, id: @deposit, deposit: { author: @deposit.author, creation_date: @deposit.creation_date, email: @deposit.email, project_url: @deposit.project_url, state: @deposit.state, status: @deposit.status, title: @deposit.title }
    assert_redirected_to deposit_path(assigns(:deposit))
  end

  test "should destroy deposit" do
    assert_difference('Deposit.count', -1) do
      delete :destroy, id: @deposit
    end

    assert_redirected_to deposits_path
  end
end
