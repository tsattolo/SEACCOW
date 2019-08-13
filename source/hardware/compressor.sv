import global_types::*;

module compressor (
    input clk,
    input reset_n,
    input [31:0] data,
    input valid,
    output [20:0] count
)

always_ff @(posedge sys_clk, negedge reset_n) begin
    CompressorTop c1(

        .ClkxCI(clk)  
        .RstxRI(~reset_n)  
        .SlCycxSI(
        SlStbxSI
        SlWexSI 
        SlSelxDI
        SlAdrxDI
        SlDatxDI
        SlDatxDO
        SlAckxSO
        SlErrxSO
        IntxSO  
        -- wishb
        MaCycxSO
        MaStbxSO
        MaWexSO 
        MaSelxDO
        MaAdrxDO
        MaDatxDO
        MaDatxDI
        MaAckxSI
        MaErrxSI


        ClkxCI   : in  std_logic;
        RstxRI   : in  std_logic;
        -- wishbone config and data input interface (32 bit access only!!)
        SlCycxSI : in  std_logic;
        SlStbxSI : in  std_logic;
        SlWexSI  : in  std_logic;
        SlSelxDI : in  std_logic_vector(3 downto 0);
        SlAdrxDI : in  std_logic_vector(4 downto 2);
        SlDatxDI : in  std_logic_vector(31 downto 0);
        SlDatxDO : out std_logic_vector(31 downto 0);
        SlAckxSO : out std_logic;
        SlErrxSO : out std_logic;
        IntxSO   : out std_logic;
        -- wishbone dma master interface
        MaCycxSO : out std_logic;
        MaStbxSO : out std_logic;
        MaWexSO  : out std_logic;
        MaSelxDO : out std_logic_vector(3 downto 0);
        MaAdrxDO : out std_logic_vector(31 downto 0);
        MaDatxDO : out std_logic_vector(31 downto 0);
        MaDatxDI : in  std_logic_vector(31 downto 0);
        MaAckxSI : in  std_logic;
        MaErrxSI : in  std_logic

end

endmodule

