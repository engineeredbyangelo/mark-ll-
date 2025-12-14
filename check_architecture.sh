#!/bin/bash

echo "🔍 Architect Nexus Mark 2 - Architecture Compliance Check"
echo "=========================================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

errors=0
warnings=0

# Check 1: No Flutter imports in domain layer
echo "📋 Check 1: Domain Layer Purity (No Flutter dependencies)"
if grep -r "package:flutter" lib/features/*/domain/ 2>/dev/null; then
    echo -e "${RED}❌ VIOLATION: Flutter imports found in domain layer${NC}"
    errors=$((errors + 1))
else
    echo -e "${GREEN}✅ PASS: Domain layer is pure${NC}"
fi
echo ""

# Check 2: No magic numbers (hardcoded dimensions)
echo "📋 Check 2: No Magic Numbers in UI"
magic_numbers=$(grep -rE "EdgeInsets\.all\([0-9]+\)|padding: [0-9]+" lib/features/*/presentation/ 2>/dev/null | grep -v "AppDimens" | wc -l)
if [ "$magic_numbers" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  WARNING: Found $magic_numbers potential magic numbers${NC}"
    echo "   Should use AppDimens constants instead"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ PASS: All dimensions use AppDimens${NC}"
fi
echo ""

# Check 3: Color token usage
echo "📋 Check 3: Cyber-Fluent Color Token Compliance"
hardcoded_colors=$(grep -rE "Color\(0x[A-F0-9]{8}\)" lib/features/*/presentation/ 2>/dev/null | grep -v "AppColors" | wc -l)
if [ "$hardcoded_colors" -gt 5 ]; then
    echo -e "${YELLOW}⚠️  WARNING: Found $hardcoded_colors hardcoded colors${NC}"
    echo "   Should use AppColors tokens"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ PASS: Colors properly tokenized${NC}"
fi
echo ""

# Check 4: File naming convention
echo "📋 Check 4: File Naming Convention (snake_case)"
non_snake_case=$(find lib -name "*[A-Z]*.dart" 2>/dev/null | wc -l)
if [ "$non_snake_case" -gt 0 ]; then
    echo -e "${RED}❌ VIOLATION: Found $non_snake_case files not in snake_case${NC}"
    find lib -name "*[A-Z]*.dart" 2>/dev/null
    errors=$((errors + 1))
else
    echo -e "${GREEN}✅ PASS: All files follow snake_case convention${NC}"
fi
echo ""

# Check 5: Widget file size
echo "📋 Check 5: Widget Modularity (Max 200 lines)"
large_files=$(find lib/features/*/presentation -name "*.dart" -exec wc -l {} \; 2>/dev/null | awk '$1 > 200 {print $2}' | wc -l)
if [ "$large_files" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  WARNING: Found $large_files widget files > 200 lines${NC}"
    find lib/features/*/presentation -name "*.dart" -exec wc -l {} \; 2>/dev/null | awk '$1 > 200 {print $1, $2}'
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ PASS: All widget files are modular${NC}"
fi
echo ""

# Check 6: Feature structure completeness
echo "📋 Check 6: Feature Structure Compliance"
for feature in lib/features/*; do
    feature_name=$(basename "$feature")
    if [ -d "$feature/domain" ] && [ -d "$feature/presentation" ]; then
        echo -e "${GREEN}✅ $feature_name: Complete structure${NC}"
    else
        echo -e "${YELLOW}⚠️  $feature_name: Missing layers${NC}"
        warnings=$((warnings + 1))
    fi
done
echo ""

# Check 7: Design system imports
echo "📋 Check 7: Design System Token Usage"
features_using_tokens=$(grep -rl "AppColors\|AppTypography\|AppDimens" lib/features/*/presentation/ 2>/dev/null | wc -l)
total_presentation_files=$(find lib/features/*/presentation -name "*.dart" 2>/dev/null | wc -l)
if [ "$features_using_tokens" -lt "$total_presentation_files" ]; then
    echo -e "${YELLOW}⚠️  WARNING: Not all presentation files use design tokens${NC}"
    echo "   $features_using_tokens/$total_presentation_files files use tokens"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ PASS: All presentation files use design tokens${NC}"
fi
echo ""

# Summary
echo "=========================================================="
echo "📊 Compliance Summary"
echo "=========================================================="
echo -e "Errors:   ${RED}$errors${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"
echo ""

if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
    echo -e "${GREEN}🎉 Perfect! Architecture fully compliant with ASI${NC}"
    exit 0
elif [ "$errors" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Architecture mostly compliant, but has $warnings warnings${NC}"
    exit 0
else
    echo -e "${RED}❌ Architecture has $errors critical violations${NC}"
    exit 1
fi
