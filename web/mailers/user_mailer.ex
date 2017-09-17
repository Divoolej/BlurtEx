defmodule BlurtEx.UserMailer do
  use Bamboo.Phoenix, view: BlurtEx.EmailView

  def reset_password(user) do
    new_email()
    |> to({user.username, user.email})
    |> from("noreply@blurtex.com")
    |> subject("BlurtEx: Reset Password")
    |> assign(:test, "sdgsdg")
    |> put_html_layout({ BlurtEx.LayoutView, "email.html" })
    |> put_text_layout({ BlurtEx.LayoutView, "email.text" })
    |> render(:reset_password)
  end
end
