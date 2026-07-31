
###################################################################################
##
## Automatically generated XDC file. Do not modify manually!
##
###################################################################################

create_clock -name MgtRefClk -period 8.000 [get_ports {MgtRefClk_p[1]}]
create_clock -name DeviceClk -period 8.000 [get_ports {DeviceClk_p}]

# Find the Clocks coming out of the CLIP PLL
set ClipPllOut0 [get_pins %ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT0]
set ClipPllOut1 [get_pins %ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT1]
set ClipPllOut2 [get_pins %ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/MMCME3_BASEx/CLKOUT2]

create_generated_clock -name DataClk2x       [get_pins $ClipPllOut0]
create_generated_clock -name DataClk         [get_pins $ClipPllOut1]
create_generated_clock -name UsrClkRxSrc     [get_pins $ClipPllOut2]

create_generated_clock -name UsrClkRx         -source [get_pins {%ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf2/I}]  -multiply_by 1 [get_pins {%ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf2/O}]
create_generated_clock -name UsrClk2RxFake    -source [get_pins {%ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf/I}]   -multiply_by 1 [get_pins {%ClipInstancePath%/NI5764FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf/O}]

set_property CLOCK_DELAY_GROUP UserClkMmcmBufgs [get_nets -of_objects [get_pin %ClipInstancePath%/NI5763FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf/O]]
set_property CLOCK_DELAY_GROUP UserClkMmcmBufgs [get_nets -of_objects [get_pin %ClipInstancePath%/NI5763FixedLogicx/CommonFixedLogicx/TimingEnginex/UserClk2Buf2/O]]


#########################
## Start instance %ClipInstancePath%/NI5763FixedLogicx/CommonFixedLogicx
#########################

set NI5763FixedLogic0 [current_instance .]
current_instance %ClipInstancePath%/NI5763FixedLogicx/CommonFixedLogicx
  
  #########################
  ## Start include, file CommonFixedLogic.xml
  #########################
  
      
      #########################
      ## Start instance TimingEnginex
      #########################
      
      set NI5763FixedLogic2 [current_instance .]
      current_instance TimingEnginex
            
            #########################
            ## Start include, file TimingEngine.xml
            #########################
            
                    set BasePath SyncClkEn
                    
                    #########################
                    ## Start include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncAsyncInBasex
                              
                              #########################
                              ## Start add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              
                              set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                              
                              set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              # False path coming in through the D pin.
                              set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                              
                              # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                              # settle out.
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncAsyncInBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSlAsyncIn.xml
                    #########################
                    
                    set BasePath FilterStdLogicx
                    
                    #########################
                    ## Start include, file FilterStdLogic.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncSlAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                                          set BasePath $BasePath/DoubleSyncAsyncInBasex
                                          
                                          #########################
                                          ## Start add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          # First create the groups that will be needed in the -from/to constraints
                                          
                                          set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                          
                                          set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                          
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                          
                                          # False path coming in through the D pin.
                                          set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                          
                                          # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                          # settle out.
                                          set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                          
                                          
                                          
                                          #########################
                                          ## End add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file FilterStdLogic.xml
                    #########################
                    
                    
                    # Ignore timing on the enable of the safebufgce
                    set_false_path -from [get_cells bClkOutEn_reg] -to [get_cells -hierarchical SafeBUFGCTRLx]
                    
                    
            
            
            #########################
            ## End include, file TimingEngine.xml
            #########################
            
            
      current_instance -quiet
      current_instance $NI5763FixedLogic2
      
      #########################
      ## End instance TimingEnginex
      #########################
      
      
      #########################
      ## Start instance ConfigGpiox
      #########################
      
      set NI5763FixedLogic2 [current_instance .]
      current_instance ConfigGpiox
            
            #########################
            ## Start include, file ConfigGpio.xml
            #########################
            
                    set BasePath FilterStdLogicx
                    
                    #########################
                    ## Start include, file FilterStdLogic.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncSlAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                                          set BasePath $BasePath/DoubleSyncAsyncInBasex
                                          
                                          #########################
                                          ## Start add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          # First create the groups that will be needed in the -from/to constraints
                                          
                                          set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                          
                                          set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                          
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                          
                                          # False path coming in through the D pin.
                                          set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                          
                                          # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                          # settle out.
                                          set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                          
                                          
                                          
                                          #########################
                                          ## End add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file FilterStdLogic.xml
                    #########################
                    
                    
            
            
            #########################
            ## End include, file ConfigGpio.xml
            #########################
            
            
      current_instance -quiet
      current_instance $NI5763FixedLogic2
      
      #########################
      ## End instance ConfigGpiox
      #########################
      
      
      #########################
      ## Start instance Jesd204bWrapperx
      #########################
      
      set NI5763FixedLogic2 [current_instance .]
      current_instance Jesd204bWrapperx
            
            #########################
            ## Start include, file Jesd204bWrapper.xml
            #########################
            
                    set BasePath ReliableClkRSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              set TNM_oSigs [get_cells "$BasePath/oSig*x/*"    -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    set BasePath UserClkRSD
                    
                    #########################
                    ## Start include, file ResetSyncDeassert.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBoolAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                                          set BasePath $BasePath/DoubleSyncSlAsyncInx
                                          
                                          #########################
                                          ## Start include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                                        set BasePath $BasePath/DoubleSyncAsyncInBasex
                                                        
                                                        #########################
                                                        ## Start add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        # First create the groups that will be needed in the -from/to constraints
                                                        
                                                        set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                                        set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                                        
                                                        set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                                        
                                                        #Second, find out the period of the clocks related to the previous groups
                                                        set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                                        
                                                        # False path coming in through the D pin.
                                                        set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                                        
                                                        # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                                        # settle out.
                                                        set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                                        
                                                        
                                                        
                                                        #########################
                                                        ## End add from file DoubleSyncAsyncInBase.xdc
                                                        #########################
                                                        
                                                        
                                          
                                          
                                          #########################
                                          ## End include, file DoubleSyncSlAsyncIn.xml
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncBoolAsyncIn.xml
                              #########################
                              
                              
                              # There is an implicit assumption that aReset coming into ResetSyncDeassert can always
                              # be treated as fully-asynchronous. This will certainly be the case if the signal is
                              # coming from a pin. But even if it's coming from an internal FF, it is never useful
                              # to treat is as synchronous. If the signal were synchronous to the output clock, we
                              # would have no need for the ResetSyncDeassert in the first place. So it's safe to
                              # except the reset path into the DoubleSync Preset (ResetSyncDeasserts always reset
                              # true), and avoid the potential for spurious Reset Recovery analysis on that path.
                              set TNM_oSigs [get_cells "$BasePath/oSig*x/*"    -filter {IS_SEQUENTIAL==true}]
                              set TNM_Prst  [get_pins -of $TNM_oSigs -filter {REF_PIN_NAME==PRE}]
                              set_false_path -to $TNM_oSigs -through $TNM_Prst
                              
                              
                    
                    
                    #########################
                    ## End include, file ResetSyncDeassert.xml
                    #########################
                    
                    
            
            
            #########################
            ## End include, file Jesd204bWrapper.xml
            #########################
            
            
      current_instance -quiet
      current_instance $NI5763FixedLogic2
      
      #########################
      ## End instance Jesd204bWrapperx
      #########################
      
      
      #########################
      ## Start instance Jesd204bWrapperx/Jesd204bAxiRegsx
      #########################
      
      set NI5763FixedLogic2 [current_instance .]
      current_instance Jesd204bWrapperx/Jesd204bAxiRegsx
            
            #########################
            ## Start include, file Jesd204bAxiRegs.xml
            #########################
            
                    set BasePath BypassDescramblerSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath SkipCharReplacementSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath AssertSyncSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath SyncOverrideValSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath StartCodeGroupSyncSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath ClearLmfcSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath CodeGrpSyncDoneSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath GtRxChanBondingDoneSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath GtRxResetsDoneSync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath AdcCodeGrpSyncRequestStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath UnExpectedKCharErrorStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath LinkErrorStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath LinkDispErrorStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath LinkNotInTableErrorStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    set BasePath LinkMisAlignmentErrorStickySync
                    
                    #########################
                    ## Start include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncBasex
                              
                              #########################
                              ## Start add from file DoubleSyncBase.xdc
                              #########################
                              
                              # First create the groups that will be needed in the -from/to constraints
                              set TNM_DS_iSig    [get_cells "$BasePath/iDlySigx/*"                        -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig_ms [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                              set TNM_DS_oSig    [get_cells "$BasePath/DoubleSyncAsyncInBasex/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                              
                              #Second, find out the period of the clocks related to the previous groups
                              set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                              
                              set_false_path -from $TNM_DS_iSig        -to $TNM_DS_oSig_ms
                              set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                              
                              
                              
                              #########################
                              ## End add from file DoubleSyncBase.xdc
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file DoubleSyncSL_RSD.xml
                    #########################
                    
                    
            
            
            #########################
            ## End include, file Jesd204bAxiRegs.xml
            #########################
            
            
      current_instance -quiet
      current_instance $NI5763FixedLogic2
      
      #########################
      ## End instance Jesd204bWrapperx/Jesd204bAxiRegsx
      #########################
      
      
      #########################
      ## Start instance Jesd204bWrapperx/Jesd204bTopx/ErrorReportingx/QpllStatusMonitoringx
      #########################
      
      set NI5763FixedLogic2 [current_instance .]
      current_instance Jesd204bWrapperx/Jesd204bTopx/ErrorReportingx/QpllStatusMonitoringx
            
            #########################
            ## Start include, file QpllStatusMonitoring.xml
            #########################
            
                    set BasePath FilterStdLogicx
                    
                    #########################
                    ## Start include, file FilterStdLogic.xml
                    #########################
                    
                              set BasePath $BasePath/DoubleSyncSlAsyncInx
                              
                              #########################
                              ## Start include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                                          set BasePath $BasePath/DoubleSyncAsyncInBasex
                                          
                                          #########################
                                          ## Start add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          # First create the groups that will be needed in the -from/to constraints
                                          
                                          set TNM_DS_oSig_ms [get_cells "$BasePath/oSig_msx/*" -filter {IS_SEQUENTIAL==true}]
                                          set TNM_DS_oSig_ms_pin [get_pins -of $TNM_DS_oSig_ms -filter {REF_PIN_NAME==D}]
                                          
                                          set TNM_DS_oSig    [get_cells "$BasePath/oSigx/*"    -filter {IS_SEQUENTIAL==true}]
                                          
                                          #Second, find out the period of the clocks related to the previous groups
                                          set T_OClkMin [expr "min([join [get_property PERIOD [get_clocks -of $TNM_DS_oSig]] ,])"]
                                          
                                          # False path coming in through the D pin.
                                          set_false_path -to $TNM_DS_oSig_ms       -through $TNM_DS_oSig_ms_pin
                                          
                                          # Half-cycle max-delay from metastable to stable flop, to give time for metastability to
                                          # settle out.
                                          set_max_delay  -from $TNM_DS_oSig_ms     -to $TNM_DS_oSig     -datapath_only [expr 0.5 * $T_OClkMin]
                                          
                                          
                                          
                                          #########################
                                          ## End add from file DoubleSyncAsyncInBase.xdc
                                          #########################
                                          
                                          
                              
                              
                              #########################
                              ## End include, file DoubleSyncSlAsyncIn.xml
                              #########################
                              
                              
                    
                    
                    #########################
                    ## End include, file FilterStdLogic.xml
                    #########################
                    
                    
            
            
            #########################
            ## End include, file QpllStatusMonitoring.xml
            #########################
            
            
      current_instance -quiet
      current_instance $NI5763FixedLogic2
      
      #########################
      ## End instance Jesd204bWrapperx/Jesd204bTopx/ErrorReportingx/QpllStatusMonitoringx
      #########################
      
      
  
  
  #########################
  ## End include, file CommonFixedLogic.xml
  #########################
  
  
  #########################
  ## Start instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
  #########################
  
  set NI5763FixedLogic1 [current_instance .]
  current_instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
      
      #########################
      ## Start add from file gtwizard_ultrascale_0.xdc
      #########################
      
      #------------------------------------------------------------------------------
      #  (c) Copyright 2013-2015 Xilinx, Inc. All rights reserved.
      #
      #  This file contains confidential and proprietary information
      #  of Xilinx, Inc. and is protected under U.S. and
      #  international copyright and other intellectual property
      #  laws.
      #
      #  DISCLAIMER
      #  This disclaimer is not a license and does not grant any
      #  rights to the materials distributed herewith. Except as
      #  otherwise provided in a valid license issued to you by
      #  Xilinx, and to the maximum extent permitted by applicable
      #  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
      #  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
      #  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
      #  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
      #  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
      #  (2) Xilinx shall not be liable (whether in contract or tort,
      #  including negligence, or under any other theory of
      #  liability) for any loss or damage of any kind or nature
      #  related to, arising under or in connection with these
      #  materials, including for any direct, or any indirect,
      #  special, incidental, or consequential loss or damage
      #  (including loss of data, profits, goodwill, or any type of
      #  loss or damage suffered as a result of any action brought
      #  by a third party) even if such damage or loss was
      #  reasonably foreseeable or Xilinx had been advised of the
      #  possibility of the same.
      #
      #  CRITICAL APPLICATIONS
      #  Xilinx products are not designed or intended to be fail-
      #  safe, or for use in any application requiring fail-safe
      #  performance, such as life-support or safety devices or
      #  systems, Class III medical devices, nuclear facilities,
      #  applications related to the deployment of airbags, or any
      #  other applications that could lead to death, personal
      #  injury, or severe property or environmental damage
      #  (individually and collectively, "Critical
      #  Applications"). Customer assumes the sole risk and
      #  liability of any use of Xilinx products in Critical
      #  Applications, subject only to applicable laws and
      #  regulations governing limitations on product liability.
      #
      #  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
      #  PART OF THIS FILE AT ALL TIMES.
      #------------------------------------------------------------------------------
      
      
      # UltraScale FPGAs Transceivers Wizard IP core-level XDC file
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y9
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y9 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin V1 [get_ports gthrxn_in[0]]
      #set_property package_pin V2 [get_ports gthrxp_in[0]]
      #set_property package_pin W3 [get_ports gthtxn_out[0]]
      #set_property package_pin W4 [get_ports gthtxp_out[0]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y10
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y10 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[26].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin T1 [get_ports gthrxn_in[1]]
      #set_property package_pin T2 [get_ports gthrxp_in[1]]
      #set_property package_pin U3 [get_ports gthtxn_out[1]]
      #set_property package_pin U4 [get_ports gthtxp_out[1]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y13
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin K1 [get_ports gthrxn_in[2]]
      #set_property package_pin K2 [get_ports gthrxp_in[2]]
      #set_property package_pin L3 [get_ports gthtxn_out[2]]
      #set_property package_pin L4 [get_ports gthtxp_out[2]]
      
      # Commands for enabled transceiver GTHE3_CHANNEL_x1y14
      # ----------------------------------------------------------------------------------------------------------------------
      
      # Channel primitive location constraint
      #set_property LOC GTHE3_CHANNEL_x1y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[-1].GTHE3_CHANNEL_PRIM_INST}]
      
      # Channel primitive serial data pin location constraints
      # (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
      #set_property package_pin H1 [get_ports gthrxn_in[3]]
      #set_property package_pin H2 [get_ports gthrxp_in[3]]
      #set_property package_pin J3 [get_ports gthtxn_out[3]]
      #set_property package_pin J4 [get_ports gthtxp_out[3]]
      
      
      # False path constraints
      # ----------------------------------------------------------------------------------------------------------------------
      
      set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
      set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]
      
      
      
      #########################
      ## End add from file gtwizard_ultrascale_0.xdc
      #########################
      
      
  current_instance -quiet
  current_instance $NI5763FixedLogic1
  
  #########################
  ## End instance Jesd204bWrapperx/Jesd204bTopx/GtWizWrapperx/gtwizard_ultrascale_0x
  #########################
  
  
current_instance -quiet
current_instance $NI5763FixedLogic0

#########################
## End instance %ClipInstancePath%/NI5763FixedLogicx/CommonFixedLogicx
#########################


#########################
## Start add from file NI5763IoTiming.xdc
#########################

# Sysref Input Delay Constraints
#                                  ______
#  _____________                  |      |         ___________          ____________
# |             |                 |      |        |           |        |            |
# |             |---{DeviceClk}---|      |--------|  SY89833  |--------|            |
# |             |                 |      |        |           |        |            |
# |    LMK      |                 | B2B  |        |___________|        |    FPGA    |
# |             |                 |      |                             |            |
# |             |                 |      |                             |            |
# |             |----{sysref}-----|      |-----------------------------|            |
# |_____________|                 |      |                             |____________|
#                                 |______|

# time constant of ps/in trace delay
set k_pd_max 0.190
set k_pd_min 0.150

# min and max time delays through system
set sysref_skew_min    -0.050
set sysref_skew_max     0.050
set sysref_dly_typ      2.600
set sysref_to_b2b_max  [expr $k_pd_max * 0.5168]
set sysref_to_b2b_min  [expr $k_pd_min * 0.5168]
set sysref_to_fpga_max [expr $k_pd_max * 1.2353]
set sysref_to_fpga_min [expr $k_pd_min * 1.2353]
set dataclk_to_b2b_max [expr $k_pd_max * 0.5188]
set dataclk_to_b2b_min [expr $k_pd_min * 0.5188]
set dataclk_to_buf_max $DataClk_Tpd_Max
set dataclk_to_buf_min $DataClk_Tpd_Min

set_input_delay -clock DeviceClk -max [expr $sysref_dly_typ + $sysref_skew_max + $sysref_to_b2b_max + $sysref_to_fpga_max - $dataclk_to_b2b_min - $dataclk_to_buf_min] [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]
set_input_delay -clock DeviceClk -min [expr $sysref_dly_typ + $sysref_skew_min + $sysref_to_b2b_min + $sysref_to_fpga_min - $dataclk_to_b2b_max - $dataclk_to_buf_max] [get_ports {dvJesd204SysRef_p dvJesd204SysRef_n}]


#########################
## End add from file NI5763IoTiming.xdc
#########################


