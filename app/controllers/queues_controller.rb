class QueuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store

  # GET /queue
  # Display the queue for the current user's store
  def show
    # Get all queue statuses for the store, ordered by position
    @queue_statuses = SellerQueueStatus.where(store: @store)
                                       .includes(:seller)
                                       .order(:position)

    # Get current user's queue status
    @current_user_status = SellerQueueStatus.find_by(store: @store, seller: current_user)

    # Get the current seller being attended (status: "attending")
    @attending_seller = @queue_statuses.find { |qs| qs.status == "attending" }

    # Get upcoming sellers (next 5 in queue)
    @upcoming_sellers = @queue_statuses.select { |qs| qs.status == "idle" }.first(5)
  end

  # POST /queue/join
  # Add the current user to the queue
  def join
    existing_status = SellerQueueStatus.find_by(store: @store, seller: current_user)

    if existing_status
      redirect_to queue_path, notice: "Você já está na fila"
      return
    end

    # Get the next position (max position + 1, or 1 if no one in queue)
    max_position = SellerQueueStatus.where(store: @store).maximum(:position) || 0
    new_position = max_position + 1

    queue_status = SellerQueueStatus.create(
      store: @store,
      seller: current_user,
      status: "idle",
      position: new_position
    )

    if queue_status.save
      # Broadcast queue update to all connected clients
      broadcast_queue_update
      redirect_to queue_path, notice: "Você foi adicionado à fila!"
    else
      redirect_to queue_path, alert: "Erro ao entrar na fila: #{queue_status.errors.full_messages.join(', ')}"
    end
  end

  # DELETE /queue/leave
  # Remove the current user from the queue
  def leave
    queue_status = SellerQueueStatus.find_by(store: @store, seller: current_user)

    if queue_status && queue_status.status == "idle"
      queue_status.destroy
      # Broadcast queue update to all connected clients
      broadcast_queue_update
      redirect_to queue_path, notice: "Você saiu da fila"
    else
      redirect_to queue_path, alert: "Você não pode sair da fila agora"
    end
  end

  private

  def broadcast_queue_update
    # Render the queue partial and broadcast it
    queue_html = render_to_string(partial: 'shared/queue_widget', locals: { store: @store })
    ActionCable.server.broadcast(
      "queue_#{@store.id}",
      type: 'queue_updated',
      html: queue_html
    )
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to stores_path, alert: "Loja não encontrada"
  end
end
