require "application_system_test_case"

class InterventionsTest < ApplicationSystemTestCase
  setup do
    @intervention = interventions(:one)
  end

  test "visiting the index" do
    visit interventions_url
    assert_selector "h1", text: "Interventions"
  end

  test "should create intervention" do
    visit interventions_url
    click_on "New intervention"

    fill_in "Description", with: @intervention.description
    fill_in "Début", with: @intervention.début
    fill_in "Fin", with: @intervention.fin
    fill_in "Temps de pause", with: @intervention.temps_de_pause
    fill_in "Workflow state", with: @intervention.workflow_state
    click_on "Create Intervention"

    assert_text "Intervention was successfully created"
    click_on "Back"
  end

  test "should update Intervention" do
    visit intervention_url(@intervention)
    click_on "Edit this intervention", match: :first

    fill_in "Description", with: @intervention.description
    fill_in "Début", with: @intervention.début
    fill_in "Fin", with: @intervention.fin
    fill_in "Temps de pause", with: @intervention.temps_de_pause
    fill_in "Workflow state", with: @intervention.workflow_state
    click_on "Update Intervention"

    assert_text "Intervention was successfully updated"
    click_on "Back"
  end

  test "should destroy Intervention" do
    visit intervention_url(@intervention)
    click_on "Destroy this intervention", match: :first

    assert_text "Intervention was successfully destroyed"
  end
end
