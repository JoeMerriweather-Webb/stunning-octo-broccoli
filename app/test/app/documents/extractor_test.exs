defmodule App.Documents.ExtractorTest do
  use App.DataCase
  alias App.Documents.Extractor

  describe "extract_data/1" do
    test "extracts data from A.xml" do
      upload = File.read!("test/support/fixtures/uploads/A.xml")

      assert %{
               plaintiffs: ["ANGELO ANGELES"],
               defendants: [
                 "HILL-ROM COMPANY, INC., an Indiana corporation",
                 "DOES 1 through 100, inclusive"
               ]
             } == Extractor.extract_data(upload)
    end

    test "extracts data from B.xml" do
      upload = File.read!("test/support/fixtures/uploads/B.xml")

      assert %{
               plaintiffs: ["Kusuma Ambelgar"],
               defendants: ["THIRUMALLAILLC, d/b/a COMMODORE MOTEL", "DOES 1-IO, inclusive"]
             } == Extractor.extract_data(upload)
    end

    test "extracts data from C.xml" do
      upload = File.read!("test/support/fixtures/uploads/C.xml")

      assert %{
               plaintiffs: ["ALBA ALVARADO"],
               defendants: [
                 "LAGUARDIA ENTERPRISES, INC., a California Corporation, dba SONSONATE GRILL",
                 "DOES 1 through 25, inclusive"
               ]
             } == Extractor.extract_data(upload)
    end

    test "returns empty lists with XML without relevant data" do
      upload = File.read!("test/support/fixtures/uploads/simple.xml")


      assert %{
               plaintiffs: [],
               defendants: []
             } == Extractor.extract_data(upload)
    end
  end
end
