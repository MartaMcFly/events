class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    @event.attendees << current_user
    if @event.save
      flash[:success] ='Your event has been successfully created!'
      redirect_to events_path(@event)
    else
      render 'new'
    end
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def show
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render 'edit'
    end
  end

  def subscribe
    @event = Event.find(params[:event_id])

     @amount = @event.price_cents
     customer = Stripe::Customer.create(
       :email => params[:stripeEmail],
       :source  => params[:stripeToken]
     )

     charge = Stripe::Charge.create(
       :customer    => customer.id,
       :amount      => @amount,
       :description => 'Rails Stripe customer',
       :currency    => 'eur'
     )

     @event.attendees << current_user
     redirect_to events_path
     flash[:success] = "You are now attending this event"

     rescue Stripe::CardError => e
       flash[:error] = e.message
       redirect_to events_path
  end

  def unsubscribe
    @event = Event.find(params[:id])
    @event.attendees.delete(current_user)
    redirect_to events_path
  end

  def event_params
    params.require(:event).permit(:name, :description, :date, :place, :price)
  end
end
