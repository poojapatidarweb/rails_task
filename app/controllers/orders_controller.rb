# frozen_string_literal: true

# order controller
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_id, only: %i[show update destroy]
  load_and_authorize_resource
  # include AddToCart
  def index
    @order_items = Order.all
  end

  def show; end

  def create
    # debugger
    p = params.require(:order_item)
    res_id = p[:restaurant_id]
    menu_id = p[:menu_item_id]
    user_id = p[:user_id]

    res = Restaurant.find(res_id)
    ord_item = res.menu_items.find(menu_id)
    order = Order.create(order_id: ord_item.id, user_id: user_id)

    if order.save
      render json: { status: { code: 200, message: 'Order item created successfully' }, data: ord_item }
    else
      render json: { status: { code: 422, message: 'Order item creation failed',
                               errors: ord_item.errors.full_messages } }
    end
  end

  def update
    # debugger
    res_id = params.require(:order_item)[:restaurant_id]
    Restaurant.find(res_id)
    params.require(:order_item)[:menu_item_id]
    # @order_item.update(order_item_params)
    if @order_item.update(order_id: ord_item.id, user_id: user_id)
      render json: { status: { code: 200, message: 'Order item updated successfully' }, data: @order_item }
    else
      render json: { status: { code: 422, message: 'Order item update failed',
                               errors: @order_item.errors.full_messages } }
    end
  end

  def destroy
    # debugger
    # @order_item = Order.find(params[:id])
    @order_item.destroy
    # render json: { status: { code: 200, message: 'Order item deleted successfully' } }
    # rescue ActiveRecord::RecordNotFound
    # render json: {message: "Order not found with the specified ID: #{params[:id]}" }, status: :not_found
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :menu_id, :quantity, :total_price)
  end

  def set_id
    @order_item = Order.find(params[:id])
  end
end
